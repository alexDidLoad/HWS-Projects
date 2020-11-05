//
//  ViewController.swift
//  Project22
//
//  Created by Alexander Ha on 11/1/20.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var circle: UIView!
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .black
        setCircle()
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //if we get authorized, continue...
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            
            // if our device is able to moinitor iBeacons, continue...
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                
                //if ranging is available continue...
                if CLLocationManager.isRangingAvailable() {
                    
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
   
        //converting a string into a UUID
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        
        //sets up the region and constraint to be used by location manager | identifier is used to read the beacon easily
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        let beaconRange = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        
        //location manager begins to monitor the distance of the reason and also to start measuring the distance between us and the beacon.
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRange)
        
        //challenge 2
        addBeaconRegion(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "Apple AirLocate 5A4BCFCE")
        addBeaconRegion(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", major: 123, minor: 456, identifier: "Apple AirLocate E2C56DB5")
        addBeaconRegion(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935", major: 123, minor: 456, identifier: "Apple AirLocate 74278BDA")
    }
    
    func update(distance: CLProximity) {
        
        UIView.animate(withDuration: 0.8) {
            
            switch distance {
            
            case .unknown:
                self.view.backgroundColor = .black
                self.distanceReading.text = "UNKNOWN"
                self.distanceReading.font = .systemFont(ofSize: 20)
                
            case .far:
                self.view.backgroundColor = .red
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = .green
                self.distanceReading.text = "RIGHT HERE"
                
            default:
                self.view.backgroundColor = .black
                self.distanceReading.text = "UNKNOWN"
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    
    func addBeaconRegion(uuidString: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
        let uuid = UUID(uuidString: uuidString)!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: identifier)
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor))
    }
    
    func setCircle() {
       
        circle.frame.size.height = 256
        circle.frame.size.width = 256
        circle.layer.zPosition = -1
        circle.layer.cornerRadius = 136
        circle.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        circle.clipsToBounds = true
        circle.layer.borderWidth = 4
        circle.layer.borderColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    
    }
    
}

