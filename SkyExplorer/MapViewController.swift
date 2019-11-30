//
//  MapViewController.swift
//  SkyExplorer
//
//  Created by Emir Kalkan on 29.11.2019.
//  Copyright © 2019 Emir Kalkan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    
    var locationManager = CLLocationManager()
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    var selectedTitle = ""
    //var selectedTitleId: UUID?
    
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
        
        if selectedTitle != "" {
            let firestoreDatabase = Firestore.firestore()
            
            firestoreDatabase.collection("Pins").addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    if snapshot?.isEmpty != true && snapshot != nil {
                        for document in snapshot!.documents {
                            let documentId = document.documentID
                                print(documentId)
                                if let title = document.get("title") as? String {
                                    self.annotationTitle = title
                                    
                                    if let subtitle = document.get("subtitle") as? String {
                                        self.annotationSubtitle = subtitle
                                        
                                        if let latitude = document.get("latitude") as? Double {
                                            self.annotationLatitude = latitude
                                            
                                            if let longitude = document.get("longitude") as? Double {
                                                self.annotationLongitude = longitude
                                                
                                                let annotation = MKPointAnnotation()
                                                annotation.title = self.annotationTitle
                                                annotation.subtitle = self.annotationSubtitle
                                                let coordinate = CLLocationCoordinate2D(latitude: self.annotationLatitude, longitude: self.annotationLongitude)
                                                annotation.coordinate = coordinate
                                                
                                                self.mapView.addAnnotation(annotation)
                                                self.nameText.text = self.annotationTitle
                                                self.commentText.text = self.annotationSubtitle
                                                
                                                self.locationManager.stopUpdatingLocation()
                                                
                                                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                                let region = MKCoordinateRegion(center: coordinate, span: span)
                                                self.mapView.setRegion(region, animated: true)
                                                
                                                //self.mapView.reloadInputViews()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
        } else {
            
        }
        
    }
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = nameText.text!
            annotation.subtitle = commentText.text
            self.mapView.addAnnotation(annotation)
        }
        
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if selectedTitle == "" {
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    //navigation "i" creator func.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.black
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    //navigation info tapped func.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
           if selectedTitle != "" {
               
               let requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
               
               CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                   //closure
                   if let placemark = placemarks {
                       if placemark.count > 0 {
                                         
                           let newPlacemark = MKPlacemark(placemark: placemark[0])
                           let item = MKMapItem(placemark: newPlacemark)
                           item.name = self.annotationTitle
                           let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                           item.openInMaps(launchOptions: launchOptions)
                        }
                    }
                }
           }
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        
        let firestoreDatabase = Firestore.firestore()
        var firestoreReference: DocumentReference? = nil
        
        let firestorePin = ["user": Auth.auth().currentUser!.email!, "latitude": chosenLatitude, "longitude": chosenLongitude, "title": self.nameText.text!, "subtitle": self.commentText.text!] as [String : Any]
        firestoreReference = firestoreDatabase.collection("Pins").addDocument(data: firestorePin, completion: { (error) in
            if error != nil {
                //self.makeAlert ekle
            }
        })
        
        NotificationCenter.default.post(name: NSNotification.Name("newPlace"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    
}
