//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/23/21.
//

import UIKit
import MapKit

extension UIViewController {
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    func showUpdateLocationAlert()  {
        let alert = UIAlertController(title: "Do you want to update your location?", message: "You have already posted a student location. Would you like to override your current location?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in
            self.performSegue(withIdentifier: "addLocation", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func logout(){
        let alert = UIAlertController(title: "Logout", message: "Are you sure to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            UdacityClient.logout { success, error in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.showAlert(message: "Logout Error", title: "Logout")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setStudentCurrentLocationPin(mapView: MKMapView, coordinate: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.setCenter(coordinate, animated: true)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region =  MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)

    }
    
}

