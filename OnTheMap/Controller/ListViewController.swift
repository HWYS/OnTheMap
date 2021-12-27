//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/20/21.
//

import UIKit

class ListViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var locations =  [StudentLocation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate  = self
        // Do any additional setup after loading the view.
        getStudentLocations()
    }
    func  getStudentLocations() {
        UdacityClient.getStudentLocation { locations, error in
            DispatchQueue.main.async {
                self.locations = locations
                self.tableView.reloadData()
            }
            
        }
    }
    
    @IBAction func addLocationClick(_ sender: Any) {
        //let isAlreadyPosted = locations.contains(where: {$0.uniqueKey == UdacityClient.Auth.accountKey})
        if !UdacityClient.Auth.objectId.isEmpty {
            showUpdateLocationAlert()
        }else{
            self.performSegue(withIdentifier: "addLocation", sender: nil)
        }
    }
    
    @IBAction func refreshClick(_ sender: Any) {
        getStudentLocations()
    }
    
    @IBAction func logoutClick(_ sender: Any) {
        logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath) as! LocationTableViewCell
        cell.studentNameLabel.text = locations[indexPath.row].firstName +  locations[indexPath.row].lastName
        cell.mediaURLLabel.text = locations[indexPath.row].mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: locations[indexPath.row].mediaURL){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            
            showAlert(message: "This is  not a valid URL", title: "Invalid URL")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
