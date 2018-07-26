//
//  Favourite.swift
//  ViewGlassAssignment
//
//  Created by Sneha Kasetty Sudarshan on 7/23/18.
//  Copyright © 2018 Sneha Kasetty Sudarshan. All rights reserved.
//

import Foundation

class Favourite: NSObject, NSCoding{
    
    
    struct Keys{
        static let Symbol = "symbol"
 
    }

    var symbol = ""

    
    override init(){}
    
    init?(symbol : String){
        self.symbol = symbol
    }
    
    // Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("symbols")
    func encode(with coder: NSCoder){
        
        coder.encode(symbol, forKey: Keys.Symbol)
        
    }
    
    required init(coder decoder: NSCoder){
        
        if let symbolObj = decoder.decodeObject(forKey: Keys.Symbol) as? String{
            symbol = symbolObj
        }
        
    }
    
    
}
