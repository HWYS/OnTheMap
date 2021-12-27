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
    var isPasswordFieldEmpty = true
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.isHidden = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        UdacityClient.login(email: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
        isLoggingIn(true)
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToHome", sender: nil)
            }
            
            //isLoggingIn(false)
        }
        else {
      
           showLoginFailure(message: error?.localizedDescription ?? "Wrong Email or Password!!")
           //isLoggingIn(false)
        }
        isLoggingIn(false)
      }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
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
            } else {
                isPasswordFieldEmpty = false
            }
        }
        
        if isEmailTextFieldEmpty == false && isPasswordFieldEmpty == false {
            //buttonEnabled(true, button: loginButton)
        } else {
            //buttonEnabled(false, button: loginButton)
        }
        
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            //login(loginButton)
        }*/
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //buttonEnabled(false, button: loginButton)
        if textField == emailTextField {
            isEmailTextFieldEmpty = true
        }
        if textField == passwordTextField {
            isPasswordFieldEmpty = true
        }
        return true
    }
        
        
    
        
}
