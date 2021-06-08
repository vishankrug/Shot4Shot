//
//  ProfileEditViewController.swift
//  Shot4Shot
//
//  Created by stlp on 6/4/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseUI

var objprofileController = ProfileViewController()
//class userInfo {
//    var firstName : String
//    var lastName : String
//    var birth : String
//    var sex : String
//    var height : Double
//    var weight : Double
//    var age : Int
//    var emergency : String
//    var address : String
//    var number : String
//    
//    init(fname : String, lname: String, birth : String, sex: String, height: Double, weight: Double, age: Int, emergency: String, address: String, number: String) {
//        firstName = fname
//        lastName = lname
//        self.birth =  birth
//        self.age = age
//        self.sex =  sex
//        self.height = height
//        self.weight = weight
//        self.emergency = emergency
//        self.address = address
//        self.number = number
//    }
//}

class ProfileEditViewController: UIViewController {

    var firstName : String = "null"
    var lastName : String = "null"
    var birthday : String = "null"
    var sex : String = "null"
    var height : Double = 0.0
    var weight : Double = 0.0
    var age : Int = 0
    var emergencyNum : String = "null"
    var address : String = "123 uw way seattle wa"
    var number : String = "123-456-3456"
    var numDrinks : Int = 4
    
    @IBOutlet weak var birthdayTextField: UITextField!
    private var datePicker : UIDatePicker?
    
    // setting up firebase reference
    let fire = Database.database().reference()
    
    override func viewDidLoad() {
        defaultValues()
        birthdayFormat()
        sexFormat()
        ageFormat()
        hieghtFormat()
    }
    
    @IBAction func theAction(_ sender: UIButton) {
              performSegue(withIdentifier: "SegueToTabBar", sender: sender)
         }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        NSLog("inside unwind action")
        performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
//        performSegue(withIdentifier: "profile", sender: self)
    }
    
    func defaultValues() {
        fire.child(currentUserUID).observeSingleEvent(of: .value)
                { (snapshot) in
                    let data = snapshot.value as! [String: Any]
                    
            self.firstNameField.text = data["fname"] as? String
            self.firstName = (data["fname"] as? String)!
            
            // Last Name Fields
            self.lastNameField.text =  data["lname"] as? String
            self.lastName = (data["lname"] as? String)!
            
            // Height Text
            let userHeight = (data["height"] as? Double)!
            let userHeightSplit = String(userHeight).components(separatedBy: ".")
            self.hieghtTextField.text = userHeightSplit[0] + " ft " + userHeightSplit[1] + " in"
            
            self.height = (data["height"] as? Double)!
            
            // setting default weight
            let userWeight = (data["weight"] as? Float)!
            self.weightSlider.value = userWeight
            self.weightLabel.text = String(Int(userWeight)) + " lbs"
            self.weight = Double(userWeight)
            
            // Sex Text
            self.sexTextField.text = data["sex"] as? String
            self.sex = (data["sex"] as? String)!
            
            // address Text
            self.addressTextField.text = data["address"] as? String
            self.address = (data["address"] as? String)!
            
            // number Text
            self.numberTextField.text = data["number"] as? String
            self.number = (data["number"] as? String)!
            
            // Birthday Text
            self.birthdayTextField.text = data["birthday"] as? String
            self.birthday = (data["birthday"] as? String)!
            
            self.numDrinks = (data["numberOfDrinksAllowed"] as? Int)!
            self.drinkTextField.text = String((data["numberOfDrinksAllowed"] as? Int)!)
            
            self.emergencyTextField.text = data["emergencyContact"] as? String
            self.emergencyNum = (data["emergencyContact"] as? String)!
            
                // delete later. will not use age filter
            self.ageTextField.text = "29"
        }
    }
    
    @IBOutlet weak var emergencyTextField: UITextField!
    @IBAction func emergencyEdit(_ sender: Any) {
        emergencyNum = emergencyTextField.text!
    }
    
    // Birthday Field
    func birthdayFormat() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.preferredDatePickerStyle = .wheels
        datePicker?.addTarget(self, action: #selector(ProfileEditViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileEditViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        birthdayTextField.inputView = datePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        
        birthday = birthdayTextField.text!
        view.endEditing(true)
    }
    
    @IBOutlet weak var drinkTextField: UITextField!
    @IBAction func drinkEdit(_ sender: Any) {
        numDrinks = Int(drinkTextField.text!)!
    }
    
    // Address Field
    @IBOutlet weak var addressTextField: UITextField!
    @IBAction func addressEdit(_ sender: Any) {
        address = addressTextField.text!
    }
    
    // Number Field
    @IBOutlet weak var numberTextField: UITextField!
    @IBAction func numberEdit(_ sender: Any) {
        number = numberTextField.text!
    }
    
    // First Name Field
    @IBOutlet weak var firstNameField: UITextField!
    @IBAction func firstNameEdit(_ sender: Any) {
        firstName = firstNameField.text!
    }
    
    // Last Name Field
    @IBOutlet weak var lastNameField: UITextField!
    @IBAction func lastNameEdit(_ sender: Any) {
        lastName = lastNameField.text!
    }
    
    // Sex Picker Field
    let sexData = ["female", "male", "prefer not to disclose"]
    @IBOutlet weak var sexTextField: UITextField!
    var sexPickerView = UIPickerView()
    func sexFormat() {
        // creating a picker view for sex
        sexTextField.inputView = sexPickerView
        
        sexPickerView.dataSource = self
        sexPickerView.delegate = self
        
        // setting tag for reference in extension below
        sexPickerView.tag = 1
    }
    
    let ageData = Array(0...100).map { String($0) }
    @IBOutlet weak var ageTextField: UITextField!
    var agePickerView = UIPickerView()
    func ageFormat() {
        // creating a picker view for sex
        ageTextField.inputView = agePickerView
        
        agePickerView.dataSource = self
        agePickerView.delegate = self
        
        // setting tag for reference in extension below
        agePickerView.tag = 2
    }
    
    // Height Picker Field
    let heightData = [["2 ft", "3 ft", "4 ft", "5 ft", "6 ft", "7 ft"],
                      ["0 in", "1 in", "2 in", "3 in", "4 in",
                       "5 in", "6 in", "7 in", "8 in", "9 in",
                       "10 in", "11 in", "12 in"]]
    @IBOutlet weak var hieghtTextField: UITextField!
    var hieghtPickerView = UIPickerView()
    func hieghtFormat() {
        // creating a picker view for sex
        hieghtTextField.inputView = hieghtPickerView
        
        hieghtPickerView.dataSource = self
        hieghtPickerView.delegate = self
        
        // setting tag for reference in extension below
        hieghtPickerView.tag = 3
    }
    
    // Weight Slider Field
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var weightLabel: UILabel!
    @IBAction func weightAction(_ sender: Any) {
        let weightInteger = Int(weightSlider.value)
        weightLabel.text = String(weightInteger) + " lbs"
        weight = Double(weightInteger)
    }
    
    // when save button is pressed
    @IBAction func saveInfo(_ sender: Any) {
        let USER = currentUserUID
        
        fire.child(USER + "/emergencyContact").setValue(emergencyNum)
        fire.child(USER + "/fname").setValue(firstName)

        fire.child(USER + "/lname").setValue(lastName)

        fire.child(USER + "/birthday").setValue(birthday)

        fire.child(USER + "/sex").setValue(sex)

        fire.child(USER + "/height").setValue(height)

        fire.child(USER + "/weight").setValue(weight)
        
        fire.child(USER + "/address").setValue(address)
        
        fire.child(USER + "/number").setValue(number)
        
        fire.child(USER + "/numberOfDrinksAllowed").setValue(numDrinks)
        
//        delayWithSeconds(10) {
//            objprofileController.getData()
//        }
        
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
}

extension ProfileEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1: // for sex picker
            return sexData[row]
        case 2:
            return ageData[row]
        case 3: // for height picker
            return heightData[component][row]
        default:
            return "null"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        
        switch pickerView.tag {
        case 1: // for sex picker
            let selectedSex = sexData[row] as String
            sex = selectedSex
            sexTextField.text = selectedSex
        case 2:
            let selectedAge = ageData[row] as String
            age = Int(selectedAge)!
            ageTextField.text = selectedAge
        case 3: // for height picker
            let selectedFT = heightData[0][pickerView.selectedRow(inComponent: 0)] as String
            let selectedIN = heightData[1][pickerView.selectedRow(inComponent: 1)] as String
            
            // formatting height into a double as "feet.inches"
            let fullHeight = String(selectedFT.split(separator: " ")[0]) + "." + String(selectedIN.split(separator: " ")[0])
            height = Double(fullHeight)!
            
            // update text field so users know what they selected
            hieghtTextField.text = selectedFT + " " + selectedIN
        
        default:
            NSLog("error")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 1: // for sex picker
            return 1
        case 2:
            return 1
        case 3: // for height picker
            return 2
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1: // for sex picker
            return sexData.count
        case 2:
            return ageData.count
        case 3: // for height picker
            return heightData[component].count
        default:
            return 1
        }
    }
}

