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

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var slider: UISlider!
    
    let kLatitude = "latitude"
    let kLongitude = "longitude"
    let kMagnitude = "magnitude"
    
    let localtions = NSMutableArray()
    var imageView = UIImageView()
    let weights = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        self.view.addSubview(self.imageView)
        let heatMap = LFHeatMap.heatMap(for: self.mapView, boost: 0.5, locations: self.localtions as? [Any], weights: self.weights as? [Any])
        self.imageView.image = heatMap
        
    }
    
}
