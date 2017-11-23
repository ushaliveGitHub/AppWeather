//
//  LocationResults.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 10/12/17.
//

import Foundation
struct LocationAddress{
    var address:String
    var coordinate:Coordinate
    
    init?(json: [String : Any]){
        guard let address = json["formatted_address"] as? String,
        let geometry = json["geometry"] as? [String : Any],
        let location = geometry["location"] as? [String : Any],
        let latitude =  location["lat"] as? Double,
            let longitude = location["lng"] as? Double else{
                return nil
        }
        self.address = address.components(separatedBy:",").first!
        self.coordinate = Coordinate(latitude: latitude, longitude: longitude)
        return
    }//end of init?
    
    init(address:String,coordinate:Coordinate){
        self.address = address
        self.coordinate = coordinate
    }
}
