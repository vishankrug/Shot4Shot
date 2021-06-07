//
//  HistoryViewController.swift
//  Shot4Shot
//
//  Created by Saurav Sawansukha on 6/7/21.
//

import UIKit
import Charts
import DropDown
import FirebaseDatabase

class HistoryViewController: UIViewController, ChartViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var alcTextTable: UILabel!
    @IBOutlet weak var alcCountTable: UILabel!
    @IBOutlet weak var safety: UILabel!
    @IBOutlet weak var drinkLimit: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonTitle: UIButton!
    @IBOutlet weak var vwDropDopwn: UIView!
    var selectedDate: String = ""
    let dropdown = DropDown()
    
    var drinkName:[String] = []
    var count:[Int] = []
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    var full_date: [String] = []
    var drinks: [Double] = []
    var barChart = BarChartView()
    
    var json: [String: Any] = [
                                "username": "vishankrug",
                                "fname": "Vishank",
                                "lname": "Rughwani",
                                "birthday": "06-01-2000",
                                "sex": "male",
                                "height": 6.0,
                                "weight": 188,
                                "emergencyContact": "2067790600",
                                "numberOfDrinksAllowed": 10,
        "history": ["06-01-2021": ["vodka": 12, "whiskey": 3], "06-02-2021": ["jager": 10, "vodka": 3, "rum": 1], "06-03-2021": ["vodka": 2, "whiskey": 1]],
                                "bloodAlcForDay": 0.05
                            ]

    var dateArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is where to load the data
        
        fire.child("vishankrug").observeSingleEvent(of: .value)
        { (snapshot) in
        
        let data = snapshot.value as? [String: Any]
            print(data)
        }
                
        // This is where to end the loading the data

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        axisFormatDelegate = self

        //getting the barChart prepped
        barChart.delegate = self
        
        //gets the history from the user
        guard let initial_date = self.json["history"] as? [String: Any] else {return}
        
        print(" is this sorted")
        var sortDate = Array(initial_date.keys).sorted(by: <)
        //goes through the history dates and gets the total drinks drank
        for key in Array(initial_date.keys).sorted(by: <){

            guard let check = initial_date[key] as? [String: Any] else {return}
            var convert = 0

            for value in check.values{
                convert = convert + (value as! Int)
                
            }
            self.full_date.append(key)
            drinks.append(Double(convert))
                    
        }
        var latestDate = sortDate.count - 1
        var lastDrank = self.full_date[latestDate]
        print(latestDate)

        var settingTable = initial_date[lastDrank] as! [String:Int]
        self.drinkName.append(contentsOf: settingTable.keys)
        self.count.append(contentsOf: settingTable.values)

        
        dropdown.anchorView = vwDropDopwn
        self.dateArray = self.full_date
        dropdown.dataSource = dateArray
        
        buttonTitle.setTitle(dateArray[dateArray.count - 1], for: UIControl.State())
        
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            //buttonTitle.setTitle("dateArray[index]", for: UIControl.State())
            self.drinkName.removeAll()
            self.count.removeAll()
            buttonTitle.setTitle(dateArray[index], for: UIControl.State())
            selectedDate = dateArray[index]
            
            var dateArray = initial_date[self.selectedDate] as! [String: Int]
            
            self.drinkName.append(contentsOf: dateArray.keys)
            self.count.append(contentsOf: dateArray.values)
            self.tableView.reloadData()
            print(self.drinkName)
            print(self.count)
        }
       
        let lastDrankCount = initial_date[lastDrank] as! [String: Int]
        var countLatestDrink = 0
        for x in lastDrankCount.values{
            countLatestDrink = x + countLatestDrink
        }
    
        let limitDrink = self.json["numberOfDrinksAllowed"] as! Int
        //print(limitDrink)
        
        self.drinkLimit.text = String(countLatestDrink) + " Drinks out of \n" + String(limitDrink)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x: 20, y: 90, width: self.view.frame.size.width - 40, height: self.view.frame.size.width - 40)
        view.addSubview(barChart)
        
        
        
        
                
        //guard let rec = self.json["history"] as? [String: Any] else {return}

        
        var jsonKeys = [BarChartDataEntry]()
        
       
        for i in 0..<self.full_date.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(self.drinks[i]) , data: full_date as AnyObject?)
            jsonKeys.append(dataEntry)
        }
        
        let set = BarChartDataSet(entries: jsonKeys, label: "Number of Drinks")
        
        
        let chartData = BarChartData(dataSet: set)
        barChart.data = chartData
        
        
        set.colors = ChartColorTemplates.joyful()
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: full_date)
        
        var bac = self.json["bloodAlcForDay"] as! Double
        
        if (bac != 0.0) {
            if (bac < 0.08) {
                safety.text = "Legally Intoxicated"
            } else if (bac < 0.40) {
                safety.text = "Very Impaired"
            } else {
                safety.text = "Serious Complications"
            }
        }
        
    }
    
    @IBAction func dropDownButton(_ sender: Any) {
        dropdown.show()
    
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return(self.drinkName.count)
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
        
        
    
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
    
        cell.textLabel?.text = self.drinkName[indexPath.row]
                
        cell.detailTextLabel?.text = String(self.count[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
        }
    


}


extension HistoryViewController: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return full_date[Int(value)]
    }
}