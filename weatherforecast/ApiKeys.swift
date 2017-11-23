//
//  ApiKeys.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 11/22/17.
//  Copyright © 2017 Usha Natarajan. All rights reserved.
//

import Foundation

// Wrapper for obtaining keys from keys.plist
func valueForAPIKey(keyname:String) -> String {
    // Get the file path for keys.plist
    let filePath = Bundle.main.path(forResource: "keys", ofType: "plist")
    
    // Put the keys in a dictionary
    let plist = NSDictionary(contentsOfFile: filePath!)
    
    // Pull the value for the key
    let value:String = plist?.object(forKey: keyname) as! String
    
    return value
}
