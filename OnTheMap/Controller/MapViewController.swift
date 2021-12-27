//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 11/25/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

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
            self.performSegue(withIdentifier: "addLocation", sender: nil)
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
            DispatchQueue.main.async {
                self.showPinsOnMap(locations: locations)
            }
            
        }
    }
    
    func showPinsOnMap(locations: [StudentLocation]) {
        DispatchQueue.main.async {
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
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
        }
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
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
