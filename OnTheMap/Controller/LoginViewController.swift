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
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled =  false
        
        isLoggingIn(false)
    }
    
    func isLoggingIn(_ loggingIn: Bool) {
        DispatchQueue.main.async {
            if loggingIn {
                
                self.activityIndicator.startAnimating()
                
            } else {
                self.activityIndicator.stopAnimating()
                
            }
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.signupButton.isEnabled = !loggingIn
        }
        
        
        
    }
    
    @IBAction func loginClick(_ sender: Any) {
        isLoggingIn(true)
        UdacityClient.login(email: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
        
        if success {
            
            self.performSegue(withIdentifier: "goToHome", sender: nil)
            
        }
        else {
            DispatchQueue.main.async {
                self.showAlert(message: error?.localizedDescription ?? "Wrong Email or Password", title: "Login")
            }
            
           
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
                isEmailTextFieldEmpty = false
            }
        }
        
        if textField == passwordTextField {
            let currenText = passwordTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                isPasswordFieldEmpty = true
                
            } else {
                isPasswordFieldEmpty = false
                
            }
        }
        
        if isEmailTextFieldEmpty == false && isPasswordFieldEmpty == false {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
        
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            isEmailTextFieldEmpty = true
        }
        if textField == passwordTextField {
            isPasswordFieldEmpty = true
        }
        return true
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! UITabBarController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
        
}
