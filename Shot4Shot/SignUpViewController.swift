//
//  SignUpViewController.swift
//  Shot4Shot
//
//  Created by Vishank Rughwani on 6/5/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emergencyContactTextField: UITextField!
    @IBOutlet weak var numberOfDrinksTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let fire = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.birthdayTextField.delegate = self
        self.addressTextField.delegate = self
        self.passwordTextField.delegate = self
        self.sexTextField.delegate = self
        self.weightTextField.delegate = self
        self.heightTextField.delegate = self
        self.usernameTextField.delegate = self
        self.emergencyContactTextField.delegate = self
        self.numberOfDrinksTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    var isExpand : Bool = false
    @objc func keyboardAppear(){
        if !isExpand{
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 400)
            self.isExpand = true
        }
    }
    
//    @objc func keyboardDisappear(){
//        if isExpand{
//            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 400)
//            self.isExpand = false
//
//        }
//    }
//    
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func validateFields() -> String? {
        
        if(firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || sexTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || weightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || heightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emergencyContactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || numberOfDrinksTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || birthdayTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            
            return "Please fill in all fields."
            
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters with at least 1 uppercase alphabet, 1 lowercase alphabet, 1 number, and 1 special character"
        }
        
        return nil
    }
    

    @IBAction func signupTapped(_ sender: Any) {
        
        let error = validateFields()
        
        
        if error != nil {
            showError(error!)
        } else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let weight = Int(weightTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let address = addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let fname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let birthday = birthdayTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let sex = sexTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let height = Double(heightTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let emergencyContact = emergencyContactTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let numberOfDrinksAllowed = Int(numberOfDrinksTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    //There was an error creating the user
                    self.showError("Error creating user")
                } else {
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    let currDate = String(dateFormatter.string(from: date))
                    
                    self.fire.child(result!.user.uid).setValue([
                        "email": email,
                        "address": address,
                        "username": username,
                        "number": phoneNumber,
                        "fname": fname,
                        "lname": lname,
                        "birthday": birthday,
                        "sex": sex,
                        "height": height!,
                        "weight": weight!,
                        "emergencyContact": emergencyContact,
                        "numberOfDrinksAllowed": numberOfDrinksAllowed!,
                        "history": [currDate: [
                                        "vodka": 0,
                                        "wine": 0,
                                        "beer": 0,
                                        "malt-liquor": 0,
                                        "rum": 0,
                                        "gin": 0,
                                        "tequila": 0]],
                        "bloodAlcForDay": 0.00,
                        "state": "Sober",
                        "uid": result!.user.uid
                    ])
                    currentUserUID = result!.user.uid
                    self.transitionToHome()
                }
            }
        }
        
        
    }
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC")
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        birthdayTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        sexTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
        heightTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        emergencyContactTextField.resignFirstResponder()
        numberOfDrinksTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        return (true)
    }
}
