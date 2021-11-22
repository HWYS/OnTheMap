//
//  ViewController.swift
//  OnTheMap
//
//  Created by HtetWaiYanSwe on 20/09/2021.
//

import UIKit

class LoginViewController: UIViewController{

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.isHidden = true
    }
    
    func isLoggingIn(_ loggingIn: Bool) {
        activityIndicator.isHidden = false
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        activityIndicator.isHidden = true
    }
    
    @IBAction func loginClick(_ sender: Any) {
        UdacityApiClient.login(with: loginTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
    
        if success {
            performSegue(withIdentifier: "goToMain", sender: nil)
            isLoggingIn(true)
        }
        else {
      
           showLoginFailure(message: error?.localizedDescription ?? "Wrong Email or Password!!")
           isLoggingIn(false)
        }
        
      }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}



extension LoginViewController: UITextViewDelegate {
    
}
