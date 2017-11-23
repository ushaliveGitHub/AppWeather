//
//  GoogleLocationEndPoint.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 10/12/17.
//

//
//  GoogleGeoCodeEndpoint.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/29/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//  Nashua , NH coordinates 42.7654° N, 71.4676° W

//MARK: Google geocoding api end point
import Foundation

enum GoogleLocationEndpoint{
    
    case search(googleApiKey:String, input: String)
    
    var baseURL:String{
        return "https://maps.googleapis.com"
    }
    
    var path:String{
        return "/maps/api/place/autocomplete/json"
        //return "/maps/api/geocode/json"
    }
    
    private struct ParamKeys{
        static let googleApiKey = "key"
        //static let components = "components"
        static let input = "input"
        static let types = "types"
    }
    
    private struct defaultValues{
        static let types = "(cities)"
    }
    
    
    //the dictionary
    var parameters: [String: Any] {
        switch self{
        //case .search(let googleApiKey, let components):
        case .search(let googleApiKey,let input):
            var parameters: [String:Any] = [
                ParamKeys.googleApiKey : googleApiKey
            ]
            //parameters[ParamKeys.components] = components
            parameters[ParamKeys.types] = defaultValues.types
            parameters[ParamKeys.input] = input
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

