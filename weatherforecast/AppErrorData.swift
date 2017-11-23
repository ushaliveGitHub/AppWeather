//
//  AppData.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 9/19/17.
//
//
//MARK: errors encountered in weathe App
import Foundation
public let Domain = "\(Bundle.main.bundleIdentifier!)"
public let ErrorDomain = Domain.components(separatedBy: ".").last!


enum AppError:Int{
    case noInternetConnection = 10
    case locationDataUnavailable = 20
    case missingHttpResponseError = 30
    case weatherInfoUnavailable = 40
    case locationNameUnknown = 50
    case permissionDenied = 60
    case poweredBy = 70
    case websiteNotFound = 80
    
    var description:String{
        switch self{
            case .noInternetConnection:
                return "Check Internet Connection."
            case .locationDataUnavailable:
               return "Unable to access Location."
            case .missingHttpResponseError:
                return "Weather Data Error."
            case .weatherInfoUnavailable:
                return "Latest Weather Info not available."
            case .locationNameUnknown:
                return "Warning: Location name unknown."
            case .permissionDenied:
                return "Location when in use permission denined."
            case .poweredBy:
                return "Powered by DarkSky."
            case .websiteNotFound:
                return "WebSite not found!"
        }
    }
}//end of AppError
