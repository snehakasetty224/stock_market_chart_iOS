//
//  StockItemDetail.swift
//  ViewGlassAssignment
//
//  Created by Sneha Kasetty Sudarshan on 7/24/18.
//  Copyright © 2018 Sneha Kasetty Sudarshan. All rights reserved.
//

import Foundation

// Structure to store the details of stock Items
struct StockItem{
    
    var symbol: String
    var name: String
    var price: Double
    var changePercent: Double
    
    init(symbol: String, name: String, price: Double, changePercent: Double){
        self.symbol = symbol
        self.name = name
        self.price = price
        self.changePercent = changePercent
    }

    
}
