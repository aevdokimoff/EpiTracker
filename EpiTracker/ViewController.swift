//
//  ViewController.swift
//  EpiTracker
//
//  Created by Artem Evdokimov on 22.05.20.
//  Copyright © 2020 Artem Evdokimov. All rights reserved.
//

import UIKit
import MapKit
import LFHeatMap
import SPAlert

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var selectMapDiseaseType: UITextField!
    @IBOutlet var selectCityTextField: UITextField!
    @IBOutlet var selectDiseaseTextField: UITextField!
    @IBOutlet var selectPeriodTextField: UITextField!
    @IBOutlet var addNewCaseEnclosureVisualEffectView: UIVisualEffectView!
    @IBOutlet var addRecoveryEnclosureVisualEffectView: UIVisualEffectView!
    @IBOutlet var addNewCaseEnclosureView: UIView!
    @IBOutlet var addRecoveryEnclosureView: UIView!
    @IBOutlet var addNewCaseButton: UIButton!
    @IBOutlet var addNewRecoveryButton: UIButton!
    
    // MARK: - Globals
    let kLatitude = "latitude"
    let kLongitude = "longitude"
    let kMagnitude = "magnitude"
    
    let localtions = NSMutableArray()
    var imageView = UIImageView()
    let weights = NSMutableArray()
    let locationManager = CLLocationManager()
    
    fileprivate let selectMapDiseasePickerView = ToolbarPickerView()
    fileprivate let selectPeriodPickerView = ToolbarPickerView()
    fileprivate let selectDiseasePickerView = ToolbarPickerView()
    fileprivate let diseasesList = ["COVID-19", "Flu"]
    fileprivate let periodsList = ["1-3 days", "4-7 days", "7-14 days", "More than 14 days"]

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupButtons()
        self.setupKeyboard()
        self.setupTextFieldAndPickerViews()
        self.setupNotifications()
        self.setupMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupViews()
    }
    
    // MARK: - UI
    func setupButtons() {
        self.addNewCaseButton.layer.cornerRadius = 4
        self.addNewRecoveryButton.layer.cornerRadius = 4
    }
    
    func setupViews() {
        if checkIsInAddedCaseMode() {
            self.addNewCaseEnclosureView.isHidden = true
            self.addRecoveryEnclosureView.isHidden = false
        } else {
            self.addNewCaseEnclosureView.isHidden = false
            self.addRecoveryEnclosureView.isHidden = true
        }
        self.addNewCaseEnclosureVisualEffectView.layer.cornerRadius = 10.0
        self.addNewCaseEnclosureVisualEffectView.layer.masksToBounds = true
        self.addNewCaseEnclosureView.addShadow(offset: CGSize.zero, color: UIColor.black, radius: 8.0, opacity: 0.15)
        self.addRecoveryEnclosureVisualEffectView.layer.cornerRadius = 10.0
        self.addRecoveryEnclosureVisualEffectView.layer.masksToBounds = true
        self.addRecoveryEnclosureView.addShadow(offset: CGSize.zero, color: UIColor.black, radius: 8.0, opacity: 0.15)
    }
    
    func setupKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func setupTextFieldAndPickerViews() {
        // TextFields
        self.selectMapDiseaseType.text = self.diseasesList[0]
        self.selectMapDiseaseType.inputView = self.selectMapDiseasePickerView
        self.selectMapDiseaseType.inputAccessoryView = self.selectMapDiseasePickerView.toolbar
        self.selectPeriodTextField.inputView = self.selectPeriodPickerView
        self.selectPeriodTextField.inputAccessoryView = self.selectPeriodPickerView.toolbar
        self.selectDiseaseTextField.inputView = self.selectDiseasePickerView
        self.selectDiseaseTextField.inputAccessoryView = self.selectDiseasePickerView.toolbar

        // PickerViews
        self.selectMapDiseasePickerView.dataSource = self
        self.selectMapDiseasePickerView.delegate = self
        self.selectMapDiseasePickerView.toolbarDelegate = self
        self.selectPeriodPickerView.dataSource = self
        self.selectPeriodPickerView.delegate = self
        self.selectPeriodPickerView.toolbarDelegate = self
        self.selectDiseasePickerView.dataSource = self
        self.selectDiseasePickerView.delegate = self
        self.selectDiseasePickerView.toolbarDelegate = self
        
        self.selectMapDiseasePickerView.reloadAllComponents()
        self.selectMapDiseasePickerView.tag = 0
        self.selectDiseasePickerView.reloadAllComponents()
        self.selectDiseasePickerView.tag = 1
        self.selectPeriodPickerView.reloadAllComponents()
        self.selectPeriodPickerView.tag = 2
    }
    
    // MARK: - Notifications
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Map
    func setupMap() {
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        self.mapView.delegate = self
        self.mapView.mapType = .standard
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        
        let dataFile = Bundle.main.path(forResource: "data", ofType: "plist")!
        let caseeData = NSArray(contentsOfFile: dataFile) as! [Dictionary<String, Any>]
        
        for casee in caseeData {
            let latitude: CLLocationDegrees = casee[kLatitude] as! CLLocationDegrees
            let longtitude: CLLocationDegrees = casee[kLongitude] as! CLLocationDegrees
            let magnitude = Double("\(casee[kMagnitude]!)")
            let location = CLLocation(latitude: latitude, longitude: longtitude)
            self.localtions.add(location)
            self.weights.add(Int(magnitude! * 10))
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 13.0)
        let center = CLLocationCoordinate2D(latitude: 39.0, longitude: -77.0)
        self.mapView.region = MKCoordinateRegion(center: center, span: span)
        
        self.imageView = UIImageView(frame: mapView.frame)
        self.imageView.contentMode = .center
        self.view.insertSubview(self.imageView, at: 1)
        let heatMap = LFHeatMap.heatMap(for: self.mapView, boost: 0.5, locations: self.localtions as? [Any], weights: self.weights as? [Any])
        self.imageView.image = heatMap
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let heatMap = LFHeatMap.heatMap(for: self.mapView, boost: 0.5, locations: self.localtions as? [Any], weights: self.weights as? [Any])
        self.imageView.image = heatMap
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            location.fetchCityAndCountry { city, country, error in
                guard let city = city, let country = country, error == nil else { return }
                print(city + ", " + country)
                self.selectCityTextField.text = city
            }
        }
    }
    
    // MARK: - Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func addNewCaseButtonDidTouch(_ sender: Any) {
        if !checkIsInAddedCaseMode() && !checkCaseAddedOnce() {
            let alertView = SPAlertView(title: "Case added", message: nil, preset: SPAlertPreset.done)
            alertView.duration = 1.0
            alertView.present()
            UserDefaults.standard.set(true, forKey: "isCaseAddedOnce")
            UserDefaults.standard.set(true, forKey: "isInAddedCaseMode")
        } else if !checkIsInAddedCaseMode() && checkCaseAddedOnce() {
            let alertView = SPAlertView(title: "Case already added", message: nil, preset: SPAlertPreset.error)
            alertView.duration = 2.5
            alertView.present()
        }
        self.setupViews()
        self.setupButtons()
    }
    
    @IBAction func addNewRecoveryButtonDidTouch(_ sender: Any) {
        if checkIsInAddedCaseMode() {
            let alertView = SPAlertView(title: "Recovery added", message: nil, preset: SPAlertPreset.done)
            alertView.duration = 1.0
            alertView.present()
            UserDefaults.standard.set(false, forKey: "isInAddedCaseMode")
        }
        self.setupViews()
        self.setupButtons()
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return self.diseasesList.count
        } else if pickerView.tag == 1 {
            return self.diseasesList.count
        } else {
            return self.periodsList.count
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return self.diseasesList[row]
        } else if pickerView.tag == 1 {
            return self.diseasesList[row]
        } else {
            return self.periodsList[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            self.selectDiseaseTextField.text = self.diseasesList[row]
        } else if pickerView.tag == 1 {
            self.selectDiseaseTextField.text = self.diseasesList[row]
        } else {
            self.selectPeriodTextField.text = self.periodsList[row]
        }
    }
}

extension ViewController: ToolbarPickerViewDelegate {
    func didTapDone(tag: Int) {
        if tag == 0 {
            let row = self.selectMapDiseasePickerView.selectedRow(inComponent: 0)
            self.selectMapDiseasePickerView.selectRow(row, inComponent: 0, animated: false)
            self.selectMapDiseaseType.text = self.diseasesList[row]
            self.selectMapDiseaseType.resignFirstResponder()
        } else if tag == 1 {
            let row = self.selectDiseasePickerView.selectedRow(inComponent: 0)
            self.selectDiseasePickerView.selectRow(row, inComponent: 0, animated: false)
            self.selectDiseaseTextField.text = self.diseasesList[row]
            self.selectDiseaseTextField.resignFirstResponder()
        } else {
            let row = self.selectPeriodPickerView.selectedRow(inComponent: 0)
            self.selectPeriodPickerView.selectRow(row, inComponent: 0, animated: false)
            self.selectPeriodTextField.text = self.periodsList[row]
            self.selectPeriodTextField.resignFirstResponder()
        }
        
    }

    func didTapCancel(tag: Int) {
        if tag == 0 {
            self.selectMapDiseaseType.text = nil
            self.selectMapDiseaseType.resignFirstResponder()
        } else if tag == 1 {
            self.selectDiseaseTextField.text = nil
            self.selectDiseaseTextField.resignFirstResponder()
        } else {
            self.selectPeriodTextField.text = nil
            self.selectPeriodTextField.resignFirstResponder()
        }
    }
}
