//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 11/25/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, RefreshViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate =  self
        getStudentLocations()
    }
    
    @IBAction func addLocationClick(_ sender: Any) {
        if !UdacityClient.Auth.objectId.isEmpty {
            showUpdateLocationAlert()
        }else{
            
            performSegue(withIdentifier: "addLocation", sender: nil)
        }
        
        
        if UdacityClient.Auth.studentPostedCoordinate.longitude > 0.0 {
            self.mapView.setCenter(UdacityClient.Auth.studentPostedCoordinate, animated: true)
            
        }
    }
    
    @IBAction func refreshClick(_ sender: Any) {
        getStudentLocations()
    }
    
    @IBAction func logoutClick(_ sender: Any) {
        logout()
    }
    
    func getStudentLocations() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UdacityClient.getStudentLocation { locations, error in
            if locations.isEmpty {
                self.showAlert(message: "Error downloading student locations", title: "Student Locations")
                self.activityIndicator.stopAnimating()
            }else {
                self.showPinsOnMap(locations: locations)
            }
        }
    }
    
    func showPinsOnMap(locations: [StudentLocation]) {
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MKPointAnnotation]()
        for dictionary in locations {
            
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
            
            
        }
        self.mapView.addAnnotations(annotations)
        activityIndicator.stopAnimating()
        
        if UdacityClient.Auth.studentPostedCoordinate.longitude > 0 {
            setStudentCurrentLocationPin(mapView: mapView, coordinate: UdacityClient.Auth.studentPostedCoordinate)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! AddLocationViewController
        viewController.isUpdateLocation =  UdacityClient.Auth.objectId.count > 0
        viewController.refreshDelegate = self
    }
    
    
   
    func refreshVC() {
        getStudentLocations()
    }
}

extension  MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if let url = URL(string: toOpen){
                    app.open(url)
                }else{
                    showAlert(message: "This is  not a valid URL", title: "Invalid URL")
                }
                
            }
        }
        
    }
    
    
}


protocol RefreshViewController{
    func refreshVC()
}
