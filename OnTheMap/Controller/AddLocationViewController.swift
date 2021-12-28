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
    
    @IBOutlet weak var findLocationButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func findLocationClick(_ sender: Any) {
        findGeoLocationByName(locationName: locationTextField.text!)
    }
    
    private func findGeoLocationByName(locationName: String){
        CLGeocoder().geocodeAddressString(locationName) { (marker, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                //self.setLoading(false)
                print("Location not found.")
            } else {
                var location: CLLocation?
                
                if let marker = marker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.goToFindLocation(location.coordinate)
                } else {
                    self.showAlert(message: "Please try again later.", title: "Error")
                    //self.setLoading(false)
                    print("There was an error.")
                }
            }
        }
    }
    
    private func goToFindLocation(_ coordinate: CLLocationCoordinate2D) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "FindLocationViewController") as! FindLocationViewController
        viewController.coordinate = coordinate
        viewController.isUpdateLocation = isUpdateLocation
        viewController.location =  locationTextField.text!
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Student info to display on Final Add Location screen
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
}
