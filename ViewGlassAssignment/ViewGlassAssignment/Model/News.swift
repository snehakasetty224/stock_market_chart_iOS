//
//  News.swift
//  ViewGlassAssignment
//
//  Created by Sneha Kasetty Sudarshan on 7/24/18.
//  Copyright © 2018 Sneha Kasetty Sudarshan. All rights reserved.
//

import Foundation

// Structure to store news information 
struct News {
    
    var heading : String
    var date : String
    var url : String
    
    init(heading: String, date: String, url: String){
        self.heading = heading
        self.date = date
        self.url = url
    }
    
}
