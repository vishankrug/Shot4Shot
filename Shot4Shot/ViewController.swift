//
//  ViewController.swift
//  Shot4Shot
//
//  Created by Vishank Rughwani on 6/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseUI

// SET GLOBAL USER VARIABLE
var currentUser = userInfo(fname: "NAME", lname: "", birth: "01-20-2000", sex: "", height: 0.0, weight: 0.0, age: 0, emergency: "SSSSS",
                           address: "123 rooselvelt way seattle wa", number: "122222222")
// USER WE ARE EDITING IN FIREBASE. Make surue to change!
let USER : String = "vishankrug"

var currentUserUID = ""

class ViewController: UIViewController {
    
    let fire = Database.database().reference()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              
              if segue.identifier == "SegueToTabBar" {
                   if let destVC = segue.destination as? UITabBarController {
                        destVC.selectedIndex = 3
                            //(sender as! UIButton).tag
                   }
              }
         }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //code to add to firebase -- must be in the format
        //will run everytime app is opened so I'll comment it out
//        fire.child("vishankrug").setValue([
//            "username": "ss299",
//            "fname": "Saurav",
//            "lname": "Sawansukha",
//            "birthday": "07-25-2000",
//            "sex": "male",
//            "height": 5.11,
//            "weight": 170,
//            "emergencyContact": "2069027455",
//            "numberOfDrinksAllowed": 20,
//            "history": ["06-01-2021": ["vodka": 28, "whiksey": 19], "06-02-2021": ["jager": 2]],
//            "bloodAlcForDay": 0.10
//        ])
//        print("hello")
        
        //reading data
//        fire.child("vishankrug").observeSingleEvent(of: .value)
//        { (snapshot) in
//            let data = snapshot.value as? [String: Any]
//            print(data)
//        }
        
        //update data
//        fire.child("vishankrug/numberOfDrinksAllowed").setValue(20)
        
        //deleting data
//        fire.child("vishankrug").removeValue()
    }
    
    
    @IBAction func Login(_ sender: Any) {
//
//        let authUI = FUIAuth.defaultAuthUI()
//
//        guard authUI != nil else {
//            return
//        }
//
//        authUI?.delegate = self
//
//        let authViewController = authUI!.authViewController()
//        
//        present(authViewController, animated: true, completion: nil)
        
    }
    

}

//extension ViewController: FUIAuthDelegate {
//    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
//
//        if error != nil {
//            return
//        }
//        //Getting userID
//        //authDataResult?.user.uid
//
//        //performSegue(withIdentifier: "loginsegue", sender: self)
//
//
//    }
//}

