//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/22/21.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {
    var location:  String = ""
    var mediaURL: String =  ""
    var  isUpdateLocation = false
    var coordinate = CLLocationCoordinate2D()
    
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        websiteTextField.delegate = self
        // Do any additional setup after loading the view.
        setLocationPin()
    }
    
    @IBAction func finishClick(_ sender: Any) {
        let body = PostLocationRequestBody(uniqueKey: UdacityClient.Auth.accountKey, firstName: "Johnathan", lastName: "Diaz", mapString: location, mediaURL: websiteTextField.text!, latitude: coordinate.latitude, longitude: coordinate.longitude)
        if isUpdateLocation {
            UdacityClient.updateLocation(objectId: UdacityClient.Auth.objectId, locationData: body, completion: handleLocationRequest(succes:error:))
        } else{
            UdacityClient.postLocation(locationData: body, completion: handleLocationRequest(succes:error:))
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleLocationRequest(succes: Bool, error: Error?) {
        if succes {
            if isUpdateLocation {
                showAlert(message: "Location updated successfully", title: "Location Update")
            }else {
                showAlert(message: "Location added successfully", title: "Location Add")
            }
            
            UdacityClient.Auth.studentPostedCoordinate = coordinate
        }else{
            if isUpdateLocation {
                showAlert(message: "Something went wrong when updating location", title: "Location Update")
            }else {
                showAlert(message: "Something went wrong when adding location", title: "Location Add")
            }
        }
        
    }
    
    func setLocationPin() {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(coordinate, animated: true)
        /*let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region =  MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)*/

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
extension FindLocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.state.isEmpty {
            let currenText = websiteTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            
                                        
            if updatedText.isEmpty && updatedText == "" {
                submitButton.isEnabled = false
            } else {
                submitButton.isEnabled = true
            }
        }
        return true
    }
}
