//
//  FriendsViewController.swift
//  Shot4Shot
//
//  Created by stlp on 6/5/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseUI

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let fire = Database.database().reference()
    
    var fullUser : [Any] = []
    var names : [String] = []
    var bac : [String] = []
    var address : [String] = []
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    private func getData() {
        fire.observe(.childAdded, with: {
                (snapshot) in
                    let data = (snapshot.value as? [String: Any])!
                    //print(data)
            
                    self.fullUser.append(data)
                    
                    // generating full name
                    NSLog((data["fname"] as? String)!)
                            let fullName = ((data["fname"] as? String)!) + " " + ((data["lname"] as? String)!)
                    self.names.append(fullName)

                            let stateLevel = (data["state"] as? String)!
                    self.bac.append(stateLevel)
            
                    let addressHere = (data["address"] as? String)!
                        self.address.append(addressHere)
                    
                    self.tableView.reloadData()
        })
    }
    
    // number of rows in table view
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //print(self.names.count)
            return self.names.count
        }
        
        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            let cell:MyCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyCustomCell
            
            cell.myCellLabel.text =  self.names[indexPath.row]
            cell.sublevel.text =  self.bac[indexPath.row]
            
            cell.addressLabel.text = self.address[indexPath.row]
            
            return cell
        }
        
        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // print("You tapped cell number \(indexPath.row).")
        }

}
