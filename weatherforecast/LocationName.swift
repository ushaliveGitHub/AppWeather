//
//  Location.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/29/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//
//MARK: to get location name from google geocoding json
import Foundation

struct LocationName{
    var coordinate:Coordinate
    var location:String?
    
    init(coordinate: Coordinate, location: String?)
    {
        self.coordinate = coordinate
        self.location = location
    }
    
    init?(json : [[String: Any]],coordinate:Coordinate){
        
        self.coordinate = coordinate
        for addressComponent in json{
            guard let types = addressComponent["types"] as? [String] else{
                continue
            }
            let locality = types.filter{
                    return $0.lowercased().contains("locality")
            }
            
            if locality.count == 0 {
                continue
            }
            guard let longName = addressComponent["long_name"] as? String else{
                    continue
            }
            self.location = longName
            return
        }
    }//end of init?
}
