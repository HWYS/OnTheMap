//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/23/21.
//

import UIKit

extension UIViewController {

    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    func showUpdateLocationAlert()  {
        let alert = UIAlertController(title: "Do you want to update your location?", message: "You have already posted a student location. Would you like to override your current location?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            viewController.isUpdateLocation = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func logout(){
        UdacityClient.logout { success, error in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.showAlert(message: "Logout Error", title: "Logout")
            }
        }
    }
    
    
}
