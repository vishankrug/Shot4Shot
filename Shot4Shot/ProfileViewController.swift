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
    
    @IBAction func refreshAgain(_ sender: Any) {
        getData()
    }
    
    let fire = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
   
    var firstName : String = ""
    var lastName : String = ""
    var birthday : String = ""
    var sex : String = ""
    var height : Double = 0.0
    var weight : Int = 0
    var address : String = ""
    var number : String = ""
    var numDrink : Int = 0
    var emergency : String = ""
    
    func getData() {
        print("RETRIEVING DATA")
        fire.child(currentUserUID).observeSingleEvent(of: .value)
        { [self] (snapshot) in
                    let data = (snapshot.value as? [String: Any])!
                    print(data)
            print(data)
            
            firstName = (data["fname"] as? String)!
            lastName = (data["lname"] as? String)!
            birthday = (data["birthday"] as? String)!
            sex = (data["sex"] as? String)!
            height = (data["height"] as? Double)!
            weight = (data["weight"] as? Int)!
            emergency = (data["emergencyContact"] as? String)!
            number = (data["number"] as? String)!
            numDrink = (data["numberOfDrinksAllowed"] as? Int)!
            address = (data["address"] as? String)!
            
            fillText()
        }
    }
    
    func fillText() {
        FullNameLabel.text = (firstName + " " + lastName)
        
        let currDate : String  = birthday
        
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
        
        let sexType = sex
        if (sexType == "Female") {
            sexLabel.text = "F"
            imageView.image = UIImage(named: "woman")
        } else if (sexType == "Male") {
            sexLabel.text = "M"
            imageView.image = UIImage(named: "dog")
        } else {
            sexLabel.text = "NA"
            imageView.image = UIImage(named: "dog")
        }
        
        let height_measure = String(height)
        let heightSplit = height_measure.components(separatedBy: ".")
        heightLabel.text = heightSplit[0] + " ft " + heightSplit[1] + " in"
        
        weightLabel.text = String(weight)
        emergencyNumberLabel.text = emergency
        phoneNumberLabel.text = number
        addressLabel.text = address
        numDrinkLabel.text = String(numDrink)
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
