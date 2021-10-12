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
    }
    
    @IBAction func loginClick(_ sender: Any) {
    }
    
}


extension LoginViewController: UITextViewDelegate {
    
}
