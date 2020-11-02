//
//  ViewController.swift
//  Project22
//
//  Created by Alexander Ha on 11/1/20.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .black
        
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //if we get authorized, continue...
        if status == .authorizedAlways {
            
            // if our device is able to moinitor iBeacons, continue...
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                
                //if ranging is available continue...
                if CLLocationManager.isRangingAvailable() {
                    
                    //do stuff here
                }
            }
        }
    }
    
    
}

