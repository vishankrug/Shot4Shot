//
//  LogInViewController.swift
//  Shot4Shot
//
//  Created by Vishank Rughwani on 6/5/21.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                currentUserUID = result!.user.uid
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let currDate = String(dateFormatter.string(from: date))
                
                //reading data
                fire.child(currentUserUID+"/history").observeSingleEvent(of: .value)
                { (snapshot) in
                    let data = snapshot.value as? [String: Any]
                    if((data?.keys.contains(currDate)) == false){
                        fire.child(currentUserUID+"/bloodAlcForDay").setValue(0.0)
                        fire.child(currentUserUID+"/state").setValue("Sober")
                        var newHist: [String: Any] = [:]
                        for key in data!.keys{
                            newHist[key] = data![key]
                        }
                        
                        newHist[currDate] = ["vodka": 0,
                                            "wine": 0,
                                            "beer": 0,
                                            "malt-liquor": 0,
                                            "rum": 0,
                                            "gin": 0,
                                            "tequila": 0
                                            ]
                                
                        fire.child(currentUserUID+"/history").setValue(newHist)
                        
                    }
                }
                
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
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
