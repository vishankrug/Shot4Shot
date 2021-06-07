//
//  ProfileViewController.swift
//  Shot4Shot
//
//  Created by stlp on 6/4/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseUI

let NUMBER_DRINK = "5"

class ProfileViewController: UIViewController {

    @IBOutlet weak var FullNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var emergencyNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numDrinkLabel: UILabel!
    
    @IBOutlet weak var imageView: RoundedImageView!
    let fire = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillText()
    }
    
    private func fillText() {
        fire.child(currentUserUID).observeSingleEvent(of: .value)
        { [self] (snapshot) in
                    let data = (snapshot.value as? [String: Any])!
                    print(data)
            FullNameLabel.text = ((data["fname"] as? String)!) + " " + ((data["lname"] as? String)!)
            
            let currDate : String  = String((data["birthday"] as? String)!)
            
            if(currDate == "") {
                ageLabel.text = "NA"
            } else {
                // since currDate is a string, we need to format into Date object to compare
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let birthdayDate = dateFormatter.date(from: currDate)!
        
                // find difference between today and birthday date
                let interval = Date() - birthdayDate
                let years = Int(interval.day! / 365)
                
                // update label with age
                ageLabel.text = String(years)
            }
            
            let sexType = (data["sex"] as? String)!
            if (sexType == "Female") {
                sexLabel.text = "F"
            } else if (sexType == "Male") {
                sexLabel.text = "M"
            } else {
                sexLabel.text = "NA"
            }
            
            let height = String((data["height"] as? Double)!)
            let heightSplit = height.components(separatedBy: ".")
            heightLabel.text = heightSplit[0] + " ft " + heightSplit[1] + " in"
            
            
            weightLabel.text = String(Int((data["weight"] as? Int)!)) + " lbs"
            
            emergencyNumberLabel.text = (data["emergencyContact"] as? String)!
            phoneNumberLabel.text = (data["number"] as? String)!
            
            addressLabel.text = (data["address"] as? String)!
            
            numDrinkLabel.text = String((data["numberOfDrinksAllowed"] as? Int)!)
            
            
                }
        
    }

    
}


@IBDesignable class RoundedImageView:UIImageView {
    @IBInspectable var borderColor:UIColor = UIColor.white {
        willSet {
            layer.borderColor = newValue.cgColor
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
    }
}

extension Date {

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}