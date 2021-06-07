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
    
    // These strings will be the data for the table view cells
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    
    var fullUser : [Any] = []
    var names : [String] = []
    var bac : [String] = []
    
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
                    print(data)
            
                    self.fullUser.append(data)
                    
                    // generating full name
                    NSLog((data["fname"] as? String)!)
                            let fullName = ((data["fname"] as? String)!) + " " + ((data["lname"] as? String)!)
                    self.names.append(fullName)

                            let bloodAlc = String((data["bloodAlcForDay"] as? Double)!)
                    self.bac.append(bloodAlc)
                    
                    self.tableView.reloadData()
        })
    }
    
    // number of rows in table view
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.names.count
        }
        
        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            let cell:MyCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyCustomCell
            
            cell.myView.backgroundColor = self.colors[indexPath.row]
            cell.myCellLabel.text =  self.names[indexPath.row]
            cell.sublevel.text =  self.bac[indexPath.row]
            return cell
        }
        
        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        }

}
