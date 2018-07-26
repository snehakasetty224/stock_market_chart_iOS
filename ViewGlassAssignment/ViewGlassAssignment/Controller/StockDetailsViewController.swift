//
//  StockDetailsViewController.swift
//  ViewGlassAssignment
//
//  Created by Sneha Kasetty Sudarshan on 7/22/18.
//  Copyright © 2018 Sneha Kasetty Sudarshan. All rights reserved.
//

import UIKit
import SwiftChart
import SwiftyJSON
import Alamofire
import SafariServices

class StockDetailsViewController: UIViewController, ChartDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {
   
    // Array to store news items
    var newsArray = [News]()
    
    var values = [String : Double]()
    
    // Getting symbol from previous view
    var symbol = ""

    var stockValues = Array<Dictionary<String, Any>>()

    @IBOutlet weak var chart: Chart!
    
    @IBOutlet weak var stockDataPicker: UIPickerView!

    @IBOutlet weak var newsTable: UITableView!
    
    var timeline = ["1day", "1month","3month", "6month","1year","2year"]
    
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        
        // URI for getting daily chart info
        getStockValues(url: "https://api.iextrading.com/1.0/stock/\(symbol.lowercased())/chart/1d",format: "HH")
        stockDataPicker.delegate = self
        stockDataPicker.dataSource = self
        
        newsTable.delegate = self
        newsTable.dataSource = self
        // setting the default stock data picker vaule to Day
        stockDataPicker.selectRow(0, inComponent: 0, animated: true)
        
        // loading news info
        getNews()
    }
    
    // Initializing Swift Chart
    func initializeChart(format:String) {
        chart.delegate = self
        chart.removeAllSeries()
        
        var serieData: [Float] = []
        var labels: [Float] = []
        var labelsAsString: Array<String> = []
        
        // Date formatter to retrieve the month names
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        for (i, value) in self.stockValues.enumerated() {
            
            serieData.append(value["close"] as! Float)
            
            // Setting label based on type of stock chart
            var labelFormat = ""
            if value["date"] == nil {
                labelFormat = dateFormatter.string(from: value["minute"] as! Date)
            }else{
                labelFormat = dateFormatter.string(from: value["date"] as! Date)
            }
            if (labels.count == 0 || labelsAsString.last != labelFormat) {
                labels.append(Float(i))
                labelsAsString.append(labelFormat)
            }
        }
        
        let series = ChartSeries(serieData)
        series.area = true
        
        // Configuring chart layout
        chart.lineWidth = 0.5
        chart.labelFont = UIFont.systemFont(ofSize: 10)
        chart.xLabels = labels
        chart.xLabelsOrientation = ChartLabelOrientation.vertical
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Float) -> String in
            return labelsAsString[labelIndex]
        }
        chart.xLabelsTextAlignment = .center
        chart.yLabelsOnRightSide = true
        chart.minY = serieData.min()!
        
        chart.add(series)
        
    }
    
    // Swift Chart delegate
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Float, left: CGFloat) {
        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            label.text = numberFormatter.string(from: NSNumber(value: value))
          
        }
        
    }
    
    //On touching the chart update the label value
    func didFinishTouchingChart(_ chart: Chart) {
        label.text = ""
    }
    
    //After touch ends do nothing
    func didEndTouchingChart(_ chart: Chart) {
        //Do nothing
    }
    
    //Get stock values from stock web service
    func getStockValues(url : String, format: String) {
        
        var array = Array<Dictionary<String, Any>>()
        Alamofire.request(url, method: .get).responseJSON{
            response in
            if response.result.isSuccess {
        
                let jsonData : JSON = JSON(response.result.value!)
                let dateFormatter = DateFormatter()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                for i in 0...jsonData.count-1 {
                    // Temporary dictionary variable to store chart info
                    var dict = Dictionary<String, Any>()
                    dict["date"] = dateFormatter.date(from: jsonData[i]["date"].stringValue )
                    // Doing the below since the REST API does not have consistent structure for charts per day vs per month/year
                    if dict["date"] == nil {
                        dict["minute"] = timeFormatter.date(from: jsonData[i]["minute"].stringValue )
                    }
                    dict["close"] = jsonData[i]["close"].floatValue
                    array.append(dict)
                }
    
            self.stockValues = array
                self.initializeChart(format:format)
            }else {
                print("Error: Issue with fetching chart info from web service")
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }
    
    
    // Picker Delegate for chart selections 1day, 1month, 3month, 6month, 1year and 2 year
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeline.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeline[row]
    }
    
    // On clicking update button it calls the aprropriate function to load the respective chart
    @IBAction func updateButton(_ sender: Any) {
        
        let pickerIndex = stockDataPicker.selectedRow(inComponent: 0)
        
        if self.timeline[pickerIndex] == "1day" {
            getStockValues(url: "https://api.iextrading.com/1.0/stock/\(symbol.lowercased())/chart/1d", format: "HH")
        }else if self.timeline[pickerIndex] == "1month"{
            getStockValues(url: "https://api.iextrading.com/1.0/stock/\(symbol.lowercased())/chart/1m", format: "MMM dd")
        }else if self.timeline[pickerIndex] == "3month"{
            getStockValues(url: "https://api.iextrading.com/1.0/stock/\(symbol.lowercased())/chart/3m", format: "MMM")
        }else if self.timeline[pickerIndex] == "6month"{
            getStockValues(url: "https://api.iextrading.com/1.0/stock/\(symbol.lowercased())/chart/6m", format: "MMM")
        }else if self.timeline[pickerIndex] == "1year"{
            getStockValues(url: "https://api.iextrading.com/1.0/stock/\(symbol.lowercased())/chart/1y", format: "yyyy MMM")
        }else{
            getStockValues(url: "https://api.iextrading.com/1.0/stock/\(symbol.lowercased())/chart/2y", format: "yyyy" )
        }
    }

    // Getting the news for the stock symbol selected from previous page
    func getNews(){
        let url = "https://api.iextrading.com/1.0/stock/market/batch?symbols=\(symbol.lowercased()),&types=quote,news"
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess{
              
                let newsJSON : JSON = JSON(response.result.value!)
                
                print("news json", newsJSON)
                for i in 0...newsJSON[self.symbol]["news"].count-1 {
                    let tempHeadin = newsJSON[self.symbol]["news"][i]["headline"].stringValue
                    let tempDate = newsJSON[self.symbol]["news"][i]["datetime"].stringValue
                    let tempURL = newsJSON[self.symbol]["news"][i]["url"].stringValue
                    let tempNews = News.init(heading: tempHeadin, date: tempDate, url: tempURL)
                    self.newsArray.append(tempNews)
                    DispatchQueue.main.async {
                        self.newsTable.reloadData()
                    }
                }
             
            }else {
                print("Error \(response.result.error ?? "error" as! Error))")
            }
        }
    }
    
    // tableview for displaying the news items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NewsCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell else {
            fatalError("Error: The dequeued cell is not an instance of NewsTableViewCell")
        }
        
        let list = newsArray[indexPath.row]
        
        cell.headLine.text = list.heading
        
        cell.dateLabel.text = list.date
    
        return cell
        
    }
    // Selecting News Item will open it in the safari Browser
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let list = newsArray[indexPath.row]

        let newsUrl = list.url

        let url = URL(string: newsUrl)!

        let svc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
        svc.delegate = self
        present(svc, animated: true, completion: {})
        
        
    }
    
    
}
