//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/22/21.
//

import UIKit
import MapKit

class SubmitLocationViewController: UIViewController {
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
        setStudentCurrentLocationPin(mapView: mapView, coordinate: coordinate)
    }
    
    @IBAction func finishClick(_ sender: Any) {
        if let _ = URL(string: websiteTextField.text!) {
            let body = PostLocationRequestBody(uniqueKey: UdacityClient.Auth.accountKey, firstName: "Johnathan", lastName: "Diaz", mapString: location, mediaURL: websiteTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), latitude: coordinate.latitude, longitude: coordinate.longitude)
            if isUpdateLocation {
                UdacityClient.updateLocation(objectId: UdacityClient.Auth.objectId, locationData: body, completion: handleLocationRequest(succes:error:))
            } else{
                UdacityClient.postLocation(locationData: body, completion: handleLocationRequest(succes:error:))
            }
            
        } else {
            showAlert(message: "This is  not a valid URL", title: "Invalid URL")
        }
    }
    
    func handleLocationRequest(succes: Bool, error: Error?) {
        if succes {
            
            UdacityClient.Auth.studentPostedCoordinate = coordinate
            goBackToHome()
            
        }else{
            if isUpdateLocation {
                showAlert(message: "Something went wrong when updating location", title: "Location Update")
            }else {
                showAlert(message: "Something went wrong when adding location", title: "Location Add")
            }
            
        }
        
    }
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goBackToHome () {
       
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /*func setLocationPin() {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(coordinate, animated: true)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region =  MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)

    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SubmitLocationViewController: UITextFieldDelegate {
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
