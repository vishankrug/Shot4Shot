//
//  ViewController.swift
//  inputScreen
//
//  Created by Pragyna Naik on 5/31/21.
//


import UIKit
import FirebaseDatabase


class homeController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let fire = Database.database().reference()
    
    var data: [String: Any] = [:]

    var alcohol = [
        [
            "name": "wine",
            "alcoholPercent": 0.12,
            "standardDrinkoz": 5.0,
            "standardDrinkgrams": 141.748
        ],
        [
            "name": "vodka",
            "alcoholPercent": 0.4,
            "standardDrinkoz": 1.5,
            "standardDrinkgrams": 130.0
        ],
        [
            "name": "beer",
            "alcoholPercent": 0.05,
            "standardDrinkoz": 12.0,
            "standardDrinkgrams": 340.194
            
        ],
        [
            "name": "malt-liquor",
            "alcoholPercent": 0.07,
            "standardDrinkoz": 8.0,
            "standardDrinkgrams": 226.796
        ],
        [
            "name": "rum",
            "alcoholPercent": 0.4,
            "standardDrinkoz": 1.5,
            "standardDrinkgrams": 42.5243
        ],
        [
            "name": "gin",
            "alcoholPercent": 0.4,
            "standardDrinkoz": 1.5,
            "standardDrinkgrams": 42.5243
        ],
        [
            "name": "tequila",
            "alcoholPercent": 0.4,
            "standardDrinkoz": 1.5,
            "standardDrinkgrams": 42.5243
        ]
    ]

    var numberShots = 0
    var numberCups = 0
    var username = currentUserUID
    var typeContainer = "Cups"
    var images = [UIImage]()
    var list: [String] = [String]()
    var numGrams = 0.0
    var currDate = ""
    var valueSelected = "vodka"
    var bac = 0.0
    
    struct alcData: Codable {
        let name: String
        let alcoholPercent: Double
        let standardDrinkoz: Double
        let standardDrinkgrams: Double
    }
    
    
    
    
    @IBOutlet weak var BAC: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var stateEmoji: UIImageView!
    @IBOutlet weak var cupCounter: UILabel!
    @IBOutlet weak var shotCounter: UILabel!
    
    @IBOutlet weak var cupView: UIImageView!
    @IBOutlet weak var shotView: UIImageView!
    
    @IBOutlet weak var addDrink: UIButton!
    @IBOutlet weak var removeDrink: UIButton!
    @IBOutlet weak var container: UISegmentedControl!
    @IBOutlet weak var drinkOptions: UIPickerView!
    
    var latestDate: String = ""
    
    // Which type of Container is chosen
    @IBAction func indexChanged(_ sender: Any) {
        switch container.selectedSegmentIndex
        {
            case 0:
                typeContainer = "Cups"
            case 1:
                typeContainer = "Shots"
            default:
                break
        }
    }
    
    
    // Add and update number of cups/shots
    @IBAction func remove(_ sender: Any) {
        if (typeContainer == "Cups") {
            if (numberCups != 0) {
                numberCups = numberCups - 1
                displayCups()
                if(numberCups < 1) {
                    cupView.animationImages = nil
                }
            }
        } else {
            if (numberShots != 0) {
                numberShots = numberShots - 1
                displayShots()
                if (numberShots < 1) {
                    shotView.animationImages = nil
                }
            }
               
        }
    }
    
    // Remove and update number of cups/shots
    @IBAction func add(_ sender: Any) {
        if (typeContainer == "Cups") {
            numberCups = numberCups + 1
            displayCups()
        } else {
            numberShots = numberShots + 1
            displayShots()
        }
    }
    
    
    // Shows how many cups are selected
    func displayCups() {
        cupCounter.text = String(numberCups) + " cups"
        var imagesListArray = [UIImage]()
        
        for i in 0...numberCups
        {
            //print("in this loop")
            let url = URL(string:"https://image.shutterstock.com/image-vector/red-plastic-cup-isolated-on-600w-744717886.jpg")
            if let data = try? Data(contentsOf: url!)
            {
              let image: UIImage = UIImage(data: data)!
              imagesListArray.append(image)
            }
        }
        
        cupView.animationImages = imagesListArray
        cupView.animationDuration = TimeInterval(2 * numberCups)
        cupView.startAnimating()
    }
    
    
    // Shows how many shots are selected
    func displayShots() {
        print(alcohol)
        var imagesListArray = [UIImage]()
        shotCounter.text = String(numberShots) + " shots"
        
        for i in 0...numberShots
        {
            //print("in shots")
            let url = URL(string:"https://image.shutterstock.com/image-vector/shot-glass-isolated-on-white-600w-287370989.jpg")
            if let data = try? Data(contentsOf: url!)
            {
              let image: UIImage = UIImage(data: data)!
              imagesListArray.append(image)
            }
            //print(imagesListArray)
        }
        
        shotView.animationImages = imagesListArray
        shotView.animationDuration = TimeInterval(2 * numberCups)
        shotView.startAnimating()
    }

    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        numberShots = 0
        numberCups = 0
        cupCounter.text = "0 cups"
        shotCounter.text = "0 shots"
        cupView.animationImages = nil
        shotView.animationImages = nil
        
        self.valueSelected = list[row] as! String
        self.valueSelected = self.valueSelected.lowercased()
        //print(self.valueSelected.lowercased())
        
            
     }
    
    // Updates all variables when save drinks is clicked
    @IBAction func saveDrinks(_ sender: Any) {
        everyFuckingThing()
//        currentDate()
//        sendData()
//        convertGrams()
//        calcBAC()
//
//        updateLabels()
//        resetInfo()
    }
    
    
    func currentDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        currDate = dateFormatter.string(from: date)
    }
    
    func everyFuckingThing() {
        var standardDrinks = 0.0
        let shotOunces = 1.5
        let cupOunces = 12.0
        var temp = 0.0
        

        if (numberShots != 0 || numberCups != 0) {
            let numberOunces = ((shotOunces * Double(numberShots)) + (cupOunces * Double(numberCups)))

          
            
            var drinkOz = alcohol[0]["standardDrinkoz"] as! Double
            
            if (valueSelected == "beer") {
                print("in send data")
                var drinkOz = alcohol[2]["standardDrinkoz"] as! Double
                standardDrinks = numberOunces / drinkOz
                print(standardDrinks)
                
            } else if (valueSelected == "wine") {
                
                var drinkOz = alcohol[0]["standardDrinkoz"] as! Double
                standardDrinks = numberOunces / drinkOz
                
            } else if (valueSelected == "vodka") {
                
                var drinkOz = alcohol[1]["standardDrinkoz"] as! Double
                standardDrinks = numberOunces / drinkOz
                
            } else if (valueSelected == "malt-liquor") {
                
                var drinkOz = alcohol[3]["standardDrinkoz"] as! Double
                standardDrinks = numberOunces / drinkOz
                
            } else if (valueSelected == "rum") {
                
                var drinkOz = alcohol[4]["standardDrinkoz"] as! Double
                standardDrinks = numberOunces / drinkOz
                
            } else if (valueSelected == "gin") {
                
                var drinkOz = alcohol[5]["standardDrinkoz"] as! Double
                standardDrinks = numberOunces / drinkOz
                
            } else if (valueSelected == "tequila") {
                
                var drinkOz = alcohol[6]["standardDrinkoz"] as! Double
                standardDrinks = numberOunces / drinkOz
                
            }
     
            var newHistory = [String: Any]()
            
            fire.child(username).observeSingleEvent(of: .value)
                    { (snapshot) in
                        let data = (snapshot.value as? [String: Any])!

                var history = data["history"] as! [String: Any]
                var sortedHistory = Array(history.keys).sorted(by: <)
                self.latestDate = sortedHistory[sortedHistory.count - 1] as! String
                var currDates = history[self.latestDate] as! [String: Double] //this is hardcoded

                
                 
                temp = Double(currDates[self.valueSelected]!)
                temp = Double(temp) + standardDrinks
                
                currDates[self.valueSelected] = temp

                history[self.latestDate]  = currDates
               
           
                newHistory = history
               
                let historyName = self.username + "/history"
                self.fire.child(historyName).setValue(newHistory)

                history = history[self.latestDate] as! [String : Any]
                for x in history.keys {
                    var hist = x as! String
                    print(history[hist])
                    var historyDouble = Double(history[hist] as! Double)
                    print("test test")
                    print(history)
                    if (hist == "beer") {
                        
                        
                        var standardDouble = self.alcohol[2]["standardDrinkgrams"] as! Double
                        
                        print(standardDouble)
                        print(historyDouble)
                        print("end test end test")
                        self.numGrams = self.numGrams + standardDouble * historyDouble
                        
                    } else if (hist == "wine") {
                        
                        var standardDouble = self.alcohol[0]["standardDrinkgrams"] as! Double
                        self.numGrams = self.numGrams + (standardDouble) * historyDouble
                        
                    } else if (hist == "vodka") {
                        
                        var standardDouble = self.alcohol[1]["standardDrinkgrams"] as! Double
                        print(standardDouble)
                        self.numGrams = self.numGrams + (standardDouble) * historyDouble
                        print(self.numGrams)
                    } else if (hist == "malt-liquor") {
                        
                        var standardDouble = self.alcohol[3]["standardDrinkgrams"] as! Double
                        
                        self.numGrams = self.numGrams + (standardDouble) * historyDouble
                        
                    } else if (hist == "rum") {
                        
                        var standardDouble = self.alcohol[4]["standardDrinkgrams"] as! Double

                        self.numGrams = self.numGrams + (standardDouble) * historyDouble
                        
                    } else if (hist == "gin") {
                        
                        var standardDouble = self.alcohol[5]["standardDrinkgrams"] as! Double

                        self.numGrams = self.numGrams + (standardDouble) * historyDouble
                        
                    } else if (hist == "tequila") { //this is meant to be tequilla
                        
                        var standardDouble = self.alcohol[6]["standardDrinkgrams"] as! Double
                        self.numGrams = self.numGrams + (standardDouble) * historyDouble
                        
                    }
                    
                }
                
                var sex = ""
                var weight = 0.0
                var rConstant = 0.0

                sex = data["sex"] as! String
                weight = data["weight"] as! Double
                weight = weight * 453.592

                if (sex == "female") {
                    rConstant = 0.55
                } else {
                    rConstant = 0.68
                }
                
                print("Start calc")
                
                print(self.numGrams)
                print(weight)
                print(rConstant)
                
                print("End calc")
                
                self.bac = (self.numGrams / (weight * rConstant)) * 100
                print("in bac")
                print(self.bac)
          
                let bacSet = self.username + "/bloodAlcForDay"
                self.fire.child(bacSet).setValue(self.bac)
               
                self.BAC.text = String(Double(Int(self.bac * 100)) / 100.0) + " % ."

                
                let currentBAC = self.bac
                
                print(currentBAC)
                if (currentBAC != 0.0) {
                    self.state.textColor = UIColor.green
                    if (currentBAC < 0.08) {
                        self.state.textColor = UIColor.yellow
                        self.state.text = "Legally Intoxicated ."
                    } else if (currentBAC < 0.40) {
                        self.state.textColor = UIColor.purple
                        self.state.text = "Impaired ."
                    } else {
                        self.state.textColor = UIColor.red
                        self.state.text = "Serious Complications ."
                    }
                }
                
                let status = self.username + "/state"
                self.fire.child(status).setValue(self.state.text)
                
            }
            
            numberShots = 0
            numberCups = 0
            cupCounter.text = "0 cups"
            shotCounter.text = "0 shots"
            cupView.animationImages = nil
            shotView.animationImages = nil
        }
        }


    
    
    func sendData() {
        var standardDrinks = 0.0
        let shotOunces = 1.5
        let cupOunces = 12.0
        var temp = 0.0
        

        let numberOunces = ((shotOunces * Double(numberShots)) + (cupOunces * Double(numberCups)))

        //print(type(of: alcohol[2]["standardDrinkoz"]!))
        
        var drinkOz = alcohol[0]["standardDrinkoz"] as! Double
        //print("Drinksss")
        //print(drinkOz)
        
        //finds out the standard drinks
        
        if (valueSelected == "beer") {
            print("in send data")
            var drinkOz = alcohol[2]["standardDrinkoz"] as! Double
            standardDrinks = numberOunces / drinkOz
            print(standardDrinks)
            
        } else if (valueSelected == "wine") {
            
            var drinkOz = alcohol[0]["standardDrinkoz"] as! Double
            standardDrinks = numberOunces / drinkOz
            
        } else if (valueSelected == "vodka") {
            
            var drinkOz = alcohol[1]["standardDrinkoz"] as! Double
            standardDrinks = numberOunces / drinkOz
            
        } else if (valueSelected == "malt-liquor") {
            
            var drinkOz = alcohol[3]["standardDrinkoz"] as! Double
            standardDrinks = numberOunces / drinkOz
            
        } else if (valueSelected == "rum") {
            
            var drinkOz = alcohol[4]["standardDrinkoz"] as! Double
            standardDrinks = numberOunces / drinkOz
            
        } else if (valueSelected == "gin") {
            
            var drinkOz = alcohol[5]["standardDrinkoz"] as! Double
            standardDrinks = numberOunces / drinkOz
            
        } else if (valueSelected == "tequila") {
            
            var drinkOz = alcohol[6]["standardDrinkoz"] as! Double
            standardDrinks = numberOunces / drinkOz
            
        }
 
        var newHistory = [String: Any]()
        
        fire.child(username).observeSingleEvent(of: .value)
                { (snapshot) in
                    let data = (snapshot.value as? [String: Any])!

            var history = data["history"] as! [String: Any]
//            print(history)
            var sortedHistory = Array(history.keys).sorted(by: <)
            self.latestDate = sortedHistory[sortedHistory.count - 1] as! String
            //print(self.latestDate)
            var currDates = history[self.latestDate] as! [String: Double] //this is hardcoded
//            print(currDates)
//            print("this is how it is")
//            print(self.valueSelected)
//            print("This is the break point")
//            print((currDates[self.valueSelected]) as! Int)
            
             
            temp = Double(currDates[self.valueSelected]!)
            temp = Double(temp) + standardDrinks
            
            currDates[self.valueSelected] = temp

            history[self.latestDate]  = currDates
           
            print(history)
            print("end send data")
            newHistory = history
           
            let historyName = self.username + "/history"
            self.fire.child(historyName).setValue(newHistory)
        }

//        fire.child(username).observeSingleEvent(of: .value)
//        { [self] (snapshot) in
//            let data = (snapshot.value as? [String: Any])!
//
//        }

    }
    
    
    func convertGrams() {
        
        fire.child(username).observeSingleEvent(of: .value)
        { [self] (snapshot) in
            var numGrams = 0.0
            let data = (snapshot.value as? [String: Any])!
            var history = data["history"] as! [String: Any]
            history = history[self.latestDate] as! [String: Any] //data is hardcoded here

            
            for x in history.keys {
                var hist = x as! String
                
                var historyDouble = Double(history[hist] as! Double)
                print("test test")
                print(history)
                if (hist == "beer") {
                    
                    
                    var standardDouble = self.alcohol[2]["standardDrinkgrams"] as! Double
                    
                    print(standardDouble)
                    print(historyDouble)
                    print("end test end test")
                    self.numGrams = self.numGrams + standardDouble * historyDouble
                    
                } else if (hist == "wine") {
                    
                    var standardDouble = self.alcohol[0]["standardDrinkgrams"] as! Double
                    self.numGrams = self.numGrams + (standardDouble) * historyDouble
                    
                } else if (hist == "vodka") {
                    
                    var standardDouble = self.alcohol[1]["standardDrinkgrams"] as! Double
                    print(standardDouble)
                    self.numGrams = self.numGrams + (standardDouble) * historyDouble
                    print(self.numGrams)
                } else if (hist == "malt-liquor") {
                    
                    var standardDouble = self.alcohol[3]["standardDrinkgrams"] as! Double
                    
                    self.numGrams = self.numGrams + (standardDouble) * historyDouble
                    
                } else if (hist == "rum") {
                    
                    var standardDouble = self.alcohol[4]["standardDrinkgrams"] as! Double

                    self.numGrams = self.numGrams + (standardDouble) * historyDouble
                    
                } else if (hist == "gin") {
                    
                    var standardDouble = self.alcohol[5]["standardDrinkgrams"] as! Double

                    self.numGrams = self.numGrams + (standardDouble) * historyDouble
                    
                } else if (hist == "tequila") { //this is meant to be tequilla
                    
                    var standardDouble = self.alcohol[6]["standardDrinkgrams"] as! Double
                    self.numGrams = self.numGrams + (standardDouble) * historyDouble
                    
                }
                
            }
            
        }
        
    }
    
    func calcBAC() {
        var sex = ""
        var weight = 0.0
        var rConstant = 0.0

        fire.child(username).observeSingleEvent(of: .value)
        { (snapshot) in
            let data = snapshot.value as? [String: Any]

            sex = data?["sex"] as! String
            weight = data?["weight"] as! Double
            weight = weight * 453.592

            if (sex == "female") {
                rConstant = 0.55
            } else {
                rConstant = 0.68
            }
            
            print("Start calc")
            
            print(self.numGrams)
            print(weight)
            print(rConstant)
            
            print("End calc")
            
            self.bac = (self.numGrams / (weight * rConstant)) * 100
            print("in bac")
            print(self.bac)
      
            let bacSet = self.username + "/bloodAlcForDay"
            self.fire.child(bacSet).setValue(self.bac)
           
            
           
        }
        
//        fire.child(username).observeSingleEvent(of: .value)
//        { (snapshot) in
//
//
//
//
//        }

    
    }
    
    
    func updateLabels() {

        fire.child(username).observeSingleEvent(of: .value)
        { [self] (snapshot) in
            
            print("before")
            let data = (snapshot.value as? [String: Any])!
            let currentBAC = data["bloodAlcForDay"] as! Double
            
            print("in update labels")
            print(currentBAC)
            self.BAC.text =  String(Double(Int(currentBAC * 100)) / 100.0) + " % ."
            
            
            print(currentBAC)
            if (currentBAC != 0.0) {
                self.state.textColor = UIColor.green
                if (currentBAC < 0.08) {
                    self.state.textColor = UIColor.yellow
                    self.state.text = "Legally Intoxicated ."
                } else if (currentBAC < 0.40) {
                    self.state.textColor = UIColor.purple
                    self.state.text = "Impaired  ."
                } else {
                    self.state.textColor = UIColor.red
                    self.state.text = "Serious Complications  ."
                }
            }
            
            let status = username + "/state"
            self.fire.child(status).setValue(self.state.text)
        }
        
      
    }
    
    func resetInfo() {
        numberShots = 0
        numberCups = 0
        cupCounter.text = "0 cups"
        shotCounter.text = "0 shots"
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        state.text = "Sober"
        BAC.text = "0.0 BAC"
        self.drinkOptions.delegate = self
        self.drinkOptions.dataSource = self
        
        //calcBAC()
        updateLabels()
        //var data: [String: Any] = [:]
        
     
            self.list = ["Vodka","Gin", "Tequila",
                    "Beer","Malt-liquor","Rum", "Wine"]

        
//        if let localData = self.readLocalFile(forName: "BAC") {
//            self.parse(jsonData: localData)
//        }
    }

    

}



