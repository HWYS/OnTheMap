//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Htet Wai Yan Swe on 12/20/21.
//

import UIKit

class ListViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, RefreshViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocations()
    }
    
    func  getStudentLocations() {
        UdacityClient.getStudentLocation { locations, error in
            DispatchQueue.main.async {
                if locations.isEmpty {
                    self.showAlert(message: "Error downloading student locations", title: "Student Locations")
                }else {
                    StudentLocationData.locations = locations
                    self.tableView.reloadData()
                }
                
            }
            
        }
    }
    
    
    @IBAction func addLocationClick(_ sender: Any) {
        if !UdacityClient.Auth.objectId.isEmpty {
            showUpdateLocationAlert()
        }else{
            performSegue(withIdentifier: "addLocation", sender: nil)
            getStudentLocations()
        }
        
    }
    
    @IBAction func refreshClick(_ sender: Any) {
        getStudentLocations()
    }
    
    @IBAction func logoutClick(_ sender: Any) {
        logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StudentLocationData.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = StudentLocationData.locations[indexPath.row]
        let cell  = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath) as! LocationTableViewCell
        cell.studentNameLabel.text = data.firstName + " " +  data.lastName
        cell.mediaURLLabel.text = data.mapString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: StudentLocationData.locations[indexPath.row].mediaURL){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            
            showAlert(message: "This is  not a valid URL", title: "Invalid URL")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! AddLocationViewController
        viewController.isUpdateLocation =  UdacityClient.Auth.objectId.count > 0
        viewController.refreshDelegate = self
    }
    
    func refreshVC() {
        getStudentLocations()
    }
}


