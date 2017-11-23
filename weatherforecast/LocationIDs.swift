//
//  LocationIDs.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 10/16/17.
//

import Foundation
import Foundation
struct LocationIDs{
    var description:String
    var uniqueLocationID:String
    
    init?(json: [String : Any]){
        guard let description = json["description"] as? String,
            let uniqueLocationID = json["place_id"] as? String else{
                return nil
        }
        self.description = description
        self.uniqueLocationID = uniqueLocationID
        return
    }
}//end of init?

