//
//  ViewController.swift
//  OnTheMap
//
//  Created by HtetWaiYanSwe on 20/09/2021.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isEmailTextFieldEmpty = true
    @IBOutlet weak var loginButton: UIButton!
    var isPasswordFieldEmpty = true
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled =  false
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        isLoggingIn(false)
    }
    
    func isLoggingIn(_ loggingIn: Bool) {
        DispatchQueue.main.async {
            if loggingIn {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    @IBAction func loginClick(_ sender: Any) {
        isLoggingIn(true)
        UdacityClient.login(email: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
        
        if success {
            
            self.performSegue(withIdentifier: "goToHome", sender: nil)
        }
        else {
            showAlert(message: error?.localizedDescription ?? "Wrong Email or Password", title: "Login")
           
        }
        isLoggingIn(false)
      }
    
    
}



extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let currenText = emailTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            
                                        
            if updatedText.isEmpty && updatedText == "" {
                isEmailTextFieldEmpty = true
            } else {
                isPasswordFieldEmpty = false
            }
        }
        
        if textField == passwordTextField {
            let currenText = passwordTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                isPasswordFieldEmpty = true
                loginButton.isEnabled  = false
            } else {
                isPasswordFieldEmpty = false
                loginButton.isEnabled  = true
            }
        }
        
        if isEmailTextFieldEmpty == false && isPasswordFieldEmpty == false {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
        
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //loginButton.isEnabled = false
        if textField == emailTextField {
            isEmailTextFieldEmpty = true
        }
        if textField == passwordTextField {
            isPasswordFieldEmpty = true
        }
        return true
    }
        
        
    
        
}
