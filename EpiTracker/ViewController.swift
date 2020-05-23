//
//  ViewController.swift
//  EpiTracker
//
//  Created by Artem on 22.05.20.
//  Copyright © 2020 Artem. All rights reserved.
//

import UIKit
import MapKit
import LFHeatMap
import SPAlert

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectCityTextField: UITextField!
    @IBOutlet weak var selectDiseaseTextField: UITextField!
    @IBOutlet weak var selectPeriodTextField: UITextField!
    @IBOutlet weak var selectVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var selectVisualEffectViewEnclosureView: UIView!
    @IBOutlet weak var addNewCaseButton: UIButton!
    
    let kLatitude = "latitude"
    let kLongitude = "longitude"
    let kMagnitude = "magnitude"
    
    let localtions = NSMutableArray()
    var imageView = UIImageView()
    let weights = NSMutableArray()
    let locationManager = CLLocationManager()
    
    fileprivate let selectPeriodPickerView = ToolbarPickerView()
    fileprivate let selectDiseasePickerView = ToolbarPickerView()
    fileprivate let diseasesList = ["Corona", "Grippe"]
    fileprivate let periodsList = ["1-3 days", "4-7 days", "7-14 days", "More than 14 days"]

    
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
    
    func setupButtons() {
        self.addNewCaseButton.layer.cornerRadius = 4
    }
    
    func setupViews() {
        self.selectVisualEffectView.layer.cornerRadius = 10.0
        self.selectVisualEffectView.layer.masksToBounds = true
        self.selectVisualEffectViewEnclosureView.addShadow(offset: CGSize.zero, color: UIColor.black, radius: 8.0, opacity: 0.15)
    }
    
    func setupKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func setupTextFieldAndPickerViews() {
        // TextFields
        self.selectPeriodTextField.inputView = self.selectPeriodPickerView
        self.selectPeriodTextField.inputAccessoryView = self.selectPeriodPickerView.toolbar
        self.selectDiseaseTextField.inputView = self.selectDiseasePickerView
        self.selectDiseaseTextField.inputAccessoryView = self.selectDiseasePickerView.toolbar

        // PickerViews
        self.selectPeriodPickerView.dataSource = self
        self.selectPeriodPickerView.delegate = self
        self.selectPeriodPickerView.toolbarDelegate = self
        self.selectDiseasePickerView.dataSource = self
        self.selectDiseasePickerView.delegate = self
        self.selectDiseasePickerView.toolbarDelegate = self
        
        self.selectDiseasePickerView.reloadAllComponents()
        self.selectDiseasePickerView.tag = 1
        self.selectPeriodPickerView.reloadAllComponents()
        self.selectPeriodPickerView.tag = 2
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
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
        
        let dataFile = Bundle.main.path(forResource: "quake", ofType: "plist")!
        let quakeData = NSArray(contentsOfFile: dataFile) as! [Dictionary<String, Any>]
        
        for quake in quakeData {
            let latitude: CLLocationDegrees = quake[kLatitude] as! CLLocationDegrees
            let longtitude: CLLocationDegrees = quake[kLongitude] as! CLLocationDegrees
            let magnitude = Double("\(quake[kMagnitude]!)")
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
    
    @IBAction func addNewCaseButtonDidTouch(_ sender: Any) {
        let alertView = SPAlertView(title: "Case added", message: nil, preset: SPAlertPreset.done)
        alertView.duration = 1.0
        alertView.present()
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return self.diseasesList.count
        } else {
            return self.periodsList.count
        }
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return self.diseasesList[row]
        } else {
            return self.periodsList[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.selectDiseaseTextField.text = self.diseasesList[row]
        } else {
            self.selectPeriodTextField.text = self.periodsList[row]
        }
    }
}

extension ViewController: ToolbarPickerViewDelegate {
    func didTapDone(tag: Int) {
        if tag == 1 {
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
        if tag == 1 {
            self.selectDiseaseTextField.text = nil
            self.selectDiseaseTextField.resignFirstResponder()
        } else {
            self.selectPeriodTextField.text = nil
            self.selectPeriodTextField.resignFirstResponder()
        }
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
