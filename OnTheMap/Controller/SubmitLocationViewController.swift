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
    var refreshDelegate: RefreshViewController?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        // Do any additional setup after loading the view.
        setStudentCurrentLocationPin(mapView: mapView, coordinate: coordinate)
    }
    
    @IBAction func finishClick(_ sender: Any) {
        if let _ = URL(string: websiteTextField.text!) {
            setLoading(isLoading: true)
            let body = PostLocationRequestBody(uniqueKey: UdacityClient.Auth.accountKey, firstName: "Ave", lastName: "K", mapString: location, mediaURL: websiteTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), latitude: coordinate.latitude, longitude: coordinate.longitude)
            if isUpdateLocation {
                UdacityClient.updateLocation(objectId: UdacityClient.Auth.objectId, locationData: body, completion: handleLocationRequest(succes:error:))
            } else{
                UdacityClient.postLocation(locationData: body, completion: handleLocationRequest(succes:error:))
            }
            
        } else {
            sendAlertMessageParameters(title: "Invalid URL", message: "This is not a valid URL")
        }
    }
    
    func handleLocationRequest(succes: Bool, error: Error?) {
        setLoading(isLoading: false)
        if succes {
            
            UdacityClient.Auth.studentPostedCoordinate = coordinate
            
            goBackToHome()
            
        }else{
            if isUpdateLocation {
                sendAlertMessageParameters(title: "Location Update", message: error?.localizedDescription ?? "Something went wrong when updating location")
            }else {
                sendAlertMessageParameters(title: "Location Add", message: error?.localizedDescription ?? "Something went wrong when adding location")
            }
            
        }
        
    }
    
    private func sendAlertMessageParameters(title: String, message: String) {
        DispatchQueue.main.async {
            self.showAlert(message: message, title: title)
        }
    }
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goBackToHome () {
        refreshDelegate?.refreshVC()
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func setLoading(isLoading: Bool){
        DispatchQueue.main.async {
            if isLoading {
                self.activityIndicator.startAnimating()
            }
            else {
                self.activityIndicator.stopAnimating()
            }
            
            self.submitButton.isEnabled = !isLoading
        }
        
    }
   

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
