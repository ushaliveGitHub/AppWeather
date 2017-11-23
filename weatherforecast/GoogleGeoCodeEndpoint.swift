//
//  GoogleGeoCodeEndpoint.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/29/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//  Nashua , NH coordinates 42.7654° N, 71.4676° W

//MARK: Google geocoding api end point
import Foundation

enum GoogleGeoCodeEndpoint{
    
    case search(googleApiKey:String, coordinate: Coordinate?)
    case searchByID(googleApiKey:String, locationID:String)
    
    var baseURL:String{
        return "https://maps.googleapis.com"
    }
    var path:String{
        return "/maps/api/geocode/json"
    }
    
    private struct ParamKeys{
        static let googleApiKey = "key"
        static let location = "latlng"
        static let place_id = "place_id"
    }
    
    private struct defaultValues{
        static let location = Coordinate(latitude: 42.7654,longitude: -71.4676).description
    }
    
   //the dictionary
    var parameters: [String: Any] {
        switch self{
        case .search(let googleApiKey, let coordinate):
            var parameters: [String:Any] = [
            ParamKeys.googleApiKey : googleApiKey
            ]
            if let coordinate = coordinate{
                parameters[ParamKeys.location] = coordinate.description
            }else{
                parameters[ParamKeys.location] = defaultValues.location
            }
            return parameters
            
        case .searchByID(let googleApiKey,let locationID):
            var parameters: [String:Any] = [
                ParamKeys.googleApiKey : googleApiKey
            ]
            parameters[ParamKeys.place_id] = locationID
            return parameters
        }
    }
    
    //the query
    var queryComponents: [URLQueryItem]{
        var components = [URLQueryItem]()
        for(key,value) in parameters{
                let queryItem = URLQueryItem(name: key, value:"\(value)")
                components.append(queryItem)
        }
        return components
    }
    
    //url Request
    var request:URLRequest{
        var components = URLComponents(string:baseURL)!
        components.path = path
        components.queryItems = queryComponents

        let url = components.url!
        return URLRequest(url:url)
    }
}//end of enum GoogleGeoEndPoint
