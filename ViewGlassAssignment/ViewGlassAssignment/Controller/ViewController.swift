//
//  ViewController.swift
//  ViewGlassAssignment
//
//  Created by Sneha Kasetty Sudarshan on 7/21/18.
//  Copyright © 2018 Sneha Kasetty Sudarshan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // url for getting the symbols from iextrading.com
    let symbolURL = "https://api.iextrading.com/1.0/ref-data/symbols"
    
    // Array of lists to store all the symbols in string format
    var allSymbolsList = [String]()
    
    // Array which contains the details of stock Item (symbol, name, price and change percent)
    var myStockDetailList = [StockItem]()
    
    // Array containing list of Favourite
    var myFavSymbolList = [Favourite]()
    
    // picker view to show all symbols
    @IBOutlet weak var symbolPicker: UIPickerView!
    
    // table view displaying the My Stocks List
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get All symbols from API
        loadAllSymbols(url: symbolURL)
        
        symbolPicker.delegate = self
        symbolPicker.dataSource = self
        myTable.delegate = self
        myTable.dataSource = self
        myTable.reloadData()
        
        if let savedSymbols = loadsymbols() {
            myFavSymbolList += savedSymbols
        }
        // Pre loading few symbols if favourite symbol list is empty
        if myFavSymbolList.count == 0 {
            myFavSymbolList.append(Favourite(symbol: "AAPL")!)
            myFavSymbolList.append(Favourite(symbol: "TDC")!)
            myFavSymbolList.append(Favourite(symbol: "AMZN")!)
            myFavSymbolList.append(Favourite(symbol: "GOOG")!)
            myFavSymbolList.append(Favourite(symbol: "TWTR")!)
        }
        
        // Get the stock details of favourite symbols from the API
        loadStockDetails()
    }
    
    // Loading All symbols from the https://api.iextrading.com/1.0/ref-data/symbols
    
    func loadAllSymbols(url: String){
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess{
                print("success got the details")
                let symbolJSON : JSON = JSON(response.result.value!)
                for i in 0...symbolJSON.count-1 {
                    let tempSymbol = symbolJSON[i]["symbol"].stringValue
                    if(tempSymbol != ""){
                        self.allSymbolsList.append(tempSymbol)
                        DispatchQueue.main.async {
                            self.symbolPicker.reloadAllComponents()
                            
                        }
                    }
                }
            }else {
                print("Error \(response.result.error ?? "error" as! Error))")
            }
        }
       
    }
    
    // Refresh button
    @IBAction func refreshPage(_ sender: UIBarButtonItem) {
                
        self.myStockDetailList.removeAll()
        loadStockDetails()
        self.myTable.reloadData()
    }
    
    
    // Loading My Favourtie Stock details to display in table, name, price and change percentage details
    func loadStockDetails(){
        for i in myFavSymbolList {
            eachStockHttp(symbol : i.symbol)
        }
    }
    // from the symbols present in favourite list , getting each stock details for that symbol
    func eachStockHttp(symbol : String  ){
        let url = "https://api.iextrading.com/1.0/stock/\(symbol)/batch?types=quote&range=1m&last=10"
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess{
                let stockJSON : JSON = JSON(response.result.value!)
                
                let tempSymbol = stockJSON["quote"]["symbol"].stringValue
                let tempName = stockJSON["quote"]["companyName"].stringValue
                let tempPrice = stockJSON["quote"]["latestPrice"].doubleValue
                let tempChange = stockJSON["quote"]["changePercent"].doubleValue
                
                self.myStockDetailList.append(StockItem(symbol: tempSymbol, name: tempName, price: tempPrice, changePercent: tempChange))
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                }
            }else {
                print("Error \(response.result.error ?? "error" as! Error))")
            }
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allSymbolsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allSymbolsList[row]
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStockDetailList.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StockCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StockTableViewCell else {
            fatalError("The dequeued cell is not an instance of StockTableViewCell.")
        }
       
        let myStockItem = myStockDetailList[indexPath.row]
        
        if myStockItem.changePercent < 0 {
            cell.changePercent.backgroundColor = UIColor.red
            cell.changePercent.text = String(format: "%.3f",myStockItem.changePercent)+"↓"
        }else{
            cell.changePercent.backgroundColor = UIColor.green
            cell.changePercent.text = String(format: "%.3f",myStockItem.changePercent)+"↑"
        }
        
        cell.priceLabel.text = String(myStockItem.price)
        
        cell.symbolTitle.text = myStockItem.symbol
        
        cell.symbolName.text = myStockItem.name
 
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let row = self.myTable.indexPathForSelectedRow!.row
        print("row", row)
        
        if segue.identifier == "stockdetails" ,
            let nextScene = segue.destination as? StockDetailsViewController {
            
            let list = self.myStockDetailList[row]
            nextScene.symbol = list.symbol
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       
        return true
    }
 
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            myFavSymbolList.remove(at: indexPath.row)
            myStockDetailList.remove(at: indexPath.row)
            saveMyFavStocks()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            DispatchQueue.main.async {
                
                self.myTable.reloadData()
            
            }
        }
    }
    
    @IBAction func addSymbolButton(_ sender: UIButton) {
        
        let symbol = allSymbolsList[symbolPicker.selectedRow(inComponent: 0)]
 
        let favoriteSymbol = Favourite(symbol: symbol)
        myFavSymbolList.append(favoriteSymbol!)
        eachStockHttp(symbol: symbol.lowercased())
        saveMyFavStocks()
        DispatchQueue.main.async {
            
            self.myTable.reloadData()
      
            
        }
    }
    
    private func saveMyFavStocks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(myFavSymbolList, toFile: Favourite.ArchiveURL.path)
        if isSuccessfulSave {
            print("success")

        } else {
       
            print("error")
        }
    }
    
    private func loadsymbols() -> [Favourite]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Favourite.ArchiveURL.path) as? [Favourite]
    }
}

