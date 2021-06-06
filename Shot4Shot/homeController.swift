//
//  ViewController.swift
//  inputScreen
//
//  Created by Pragyna Naik on 5/31/21.
//


import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
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
            "standardDrinkgrams": 130
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
    var username = "vishankrug"
    var typeContainer = "Cups"
    var images = [UIImage]()
    var list: [String] = [String]()
    var numGrams = 0
    var currDate = ""
    var valueSelected = ""
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
            }
        } else {
            if (numberShots != 0) {
                numberShots = numberShots - 1
                displayShots()
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
            print("in this loop")
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
        var imagesListArray = [UIImage]()
        shotCounter.text = String(numberShots) + " shots"
        
        for i in 0...numberShots
        {
            print("in shots")
            let url = URL(string:"https://image.shutterstock.com/image-vector/shot-glass-isolated-on-white-600w-287370989.jpg")
            if let data = try? Data(contentsOf: url!)
            {
              let image: UIImage = UIImage(data: data)!
              imagesListArray.append(image)
            }
            print(imagesListArray)
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

            valueSelected = list[row] as String
     }
    
    // Updates all variables when save drinks is clicked
    @IBAction func saveDrinks(_ sender: Any) {
        currentDate()
        sendData()
     //   convertGrams()
    //    calcBAC()
     //   updateLabels()
    //    resetInfo()
    }
    
    
    func currentDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        currDate = dateFormatter.string(from: date)
    }
    
    func sendData() {
        var standardDrinks = 0.0
        let shotOunces = 1.5
        let cupOunces = 12.0
        var temp = 0.0
        

        let numberOunces = ((shotOunces * Double(numberShots)) + (cupOunces * Double(numberCups)))

        print(type(of: alcohol[2]["standardDrinkoz"]!))
        
//        if (valueSelected == "beer") {
//            standardDrinks = Double(numberOunces) / (alcohol[2]["standardDrinkoz"]!)
//        } else if (valueSelected == "wine") {
//            standardDrinks = numberOunces / (alcohol[2]["standardDrinkoz"]!)
//        } else if (valueSelected == "vodka") {
//            standardDrinks = numberOunces / (alcohol[2]["standardDrinkoz"]!)
//        } else if (valueSelected == "malt-liquor") {
//            standardDrinks = numberOunces / (alcohol[2]["standardDrinkoz"]!)
//        } else if (valueSelected == "rum") {
//            standardDrinks = numberOunces / (alcohol[2]["standardDrinkoz"]!)
//        } else if (valueSelected == "gin") {
//            standardDrinks = numberOunces / (alcohol[2]["standardDrinkoz"]!)
//        } else if (valueSelected == "tequila") {
//            standardDrinks = numberOunces / (alcohol[2]["standardDrinkoz"]!)
//        }

        
        
        fire.child(username).observeSingleEvent(of: .value)
                { (snapshot) in
                    let data = snapshot.value as? [String: Any]

            let history = data["history"][currDate]
            temp = history[valueSelected]
        }


        let historyName = username + "history"

        fire.child(historyName).setValue(temp)
    }
    
    func convertGrams() {
        
        fire.child(username).observeSingleEvent(of: .value)
                { (snapshot) in
                    let data = snapshot.value as? [String: Any]

            let history = data["history"][currDate]
            
            
            for hist in history {
                
            }
        }
        
    }
    
    func calcBAC() {
        var sex = ""
        var weight = 0
        var rConstant = 0

        fire.child(username).observeSingleEvent(of: .value)
        { (snapshot) in
            let data = snapshot.value as? [String: Any]

            sex = data["sex"]
            weight = data["weight"]

            if (sex == "female") {
                rConstant = 0.55
            } else {
                rConstant = 0.68
            }
        }

        bac = (numGrams / (weight * rConstant)) * 100

        let bacSet = username + "bloodAlcForDay"

        fire.child(bacSet).setValue(bac)
    }
    
    
    func updateLabels() {
        BAC.text = String(bac)
        if (bac != 0.0) {
            if (bac < 0.08) {
                state.text = "Legally Intoxicated"
            } else if (bac < 0.40) {
                state.text = "Very Impaired"
            } else {
                state.text = "Serious Complications"
            }
        }
        
    }
    
    func resetInfo() {
        numberShots = 0
        numberCups = 0
        cupCounter.text = "0 cups"
        shotCounter.text = "0 shots"
    }
    
    
    // Reading data from JSON file
    func readLocalFile(forName name: String) -> Data? {
        do {
            print("In read localFile")
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func parse(jsonData: Data) {
        do {
            print("in parse Function")
            let decodedData = try JSONDecoder().decode(alcData.self,
                                                       from: jsonData)
            
            print(decodedData)
            
            
            print("Name: ", decodedData.name)
            print("grams: ", decodedData.standardDrinkgrams)
            print("===================================")
        } catch {
            print("decode error")
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        state.text = "Sober"
        BAC.text = "0 %"
        self.drinkOptions.delegate = self
        self.drinkOptions.dataSource = self
        list = ["Vodka","Gin", "Tequila",
                "Beer","Whiskey","Rum", "Wine"]
        
        currentDate()
        if let localData = self.readLocalFile(forName: "BAC") {
            self.parse(jsonData: localData)
        }
    }

    

}



