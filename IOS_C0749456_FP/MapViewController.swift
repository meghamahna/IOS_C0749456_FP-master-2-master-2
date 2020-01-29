//
//  MapViewController.swift
//  IOS_C0749456_FP
//
//  Created by Megha Mahna on 2020-01-28.
//  Copyright © 2020 Megha. All rights reserved.
//

import UIKit
import MapKit
import  CoreLocation
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
               locationManager.requestWhenInUseAuthorization()
               locationManager.startUpdatingLocation()
               
               mapView.showsUserLocation = true
               print("user latitude = \(latitude)")
               print("user longitude = \(longitude)")
        let noteLocation = CLLocation(latitude: latitude!, longitude: longitude!)
                 super.viewDidLoad(); self.navigationController!.setNavigationBarHidden(false, animated: true)
               self.title = "Note Location"
               let regionRadius: CLLocationDistance = 350
               let coordinateRegion = MKCoordinateRegion(center: noteLocation.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
               self.mapView.setRegion(coordinateRegion, animated: true)
               
               
               // Drop a pin at user's Current Location
               let annotation: MKPointAnnotation = MKPointAnnotation()
               annotation.coordinate = CLLocationCoordinate2DMake(noteLocation.coordinate.latitude, noteLocation.coordinate.longitude);
               annotation.title = "Note Location"
               annotation.subtitle = "\(latitude),\(longitude)"
               self.mapView.addAnnotation(annotation)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
