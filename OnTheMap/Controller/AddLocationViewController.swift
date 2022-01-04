//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/22/21.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    var isUpdateLocation = false
    var refreshDelegate: RefreshViewController?
    private var pinCoordinate = CLLocationCoordinate2D()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findLocationButton.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationClick(_ sender: Any) {
        findGeoLocationByName(locationName: locationTextField.text!)
    }
    
    private func findGeoLocationByName(locationName: String){
        setLoading(isLoading: true)
        CLGeocoder().geocodeAddressString(locationName) { (marker, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
               
                self.setLoading(isLoading: false)
            } else {
                var location: CLLocation?
                
                if let marker = marker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.goToFindLocation(location.coordinate)
                } else {
                    self.showAlert(message: "Please try again later.", title: "Error")
                    self.setLoading(isLoading: false)
                }
            }
        }
    }
    
    private func goToFindLocation(_ coordinate: CLLocationCoordinate2D) {
        setLoading(isLoading: false)
        self.pinCoordinate  = coordinate
        performSegue(withIdentifier: "findLocation", sender: nil)
        
    }
    
    private func setLoading(isLoading: Bool){
        DispatchQueue.main.async {
            if isLoading {
                self.activityIndicator.startAnimating()
            }
            else {
                self.activityIndicator.stopAnimating()
            }
            
            self.findLocationButton.isEnabled = !isLoading
        }
        
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let viewController = segue.destination as! SubmitLocationViewController
        viewController.coordinate = pinCoordinate
        viewController.location = locationTextField.text!
        viewController.isUpdateLocation = isUpdateLocation
        viewController.refreshDelegate = refreshDelegate
        present(viewController, animated: true, completion: nil)
    }
    

}
extension AddLocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.state.isEmpty {
            let currenText = locationTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
                                        
            if updatedText.isEmpty && updatedText == "" {
                findLocationButton.isEnabled = false
            } else {
                findLocationButton.isEnabled = true
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
