//
//  ViewController.swift
//  Shot4Shot
//
//  Created by Vishank Rughwani on 6/1/21.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let fire = Database.database().reference()
        
        //code to add to firebase -- must be in the format
        //will run everytime app is opened so I'll comment it out
//        fire.child("vishankrug").setValue([
//            "username": "vishankrug",
//            "fname": "Vishank",
//            "lname": "Rughwani",
//            "birthday": "06-01-2000",
//            "sex": "male",
//            "height": 6.0,
//            "weight": 188,
//            "emergencyContact": "2067790600",
//            "numberOfDrinksAllowed": 10,
//            "history": ["06-01-2021": ["vodka": 10, "whiksey": 10], "06-02-2021": ["jager": 10]],
//            "bloodAlcForDay": 0.05
//        ])
        
        //reading data
//        fire.child("vishankrug").observeSingleEvent(of: .value)
//        { (snapshot) in
//            let data = snapshot.value as? [String: Any]
//            print(data)
//        }
        
        //update data
//        fire.child("vishankrug/numberOfDrinksAllowed").setValue(20)
        

    }


}

