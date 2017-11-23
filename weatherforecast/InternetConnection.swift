//
//  InternetConnection.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 10/31/17.
//

import Foundation
import UIKit
//MARK: To monitor internet connection status change
extension WeatherViewController{
    
    func reachabilityStatusChanged(notification: NSNotification){
        
        guard let reachability = notification.object as? Reachability else{
            return
        }
        if reachability.isReachable{
            //googleGeoCodingClient = GoogleGeoCodingClient(googleApiKey: googleApiKey)
            googleGeoCodingClient = GoogleGeoCodingClient(googleApiKey: googleApiKeyByID)
            darkSkyClient = DarkSkyClient(ApiKey: ApiKey)
            self.internet = true
            getLocationPermission(flag:true)
        }else{
            googleGeoCodingClient = nil
            darkSkyClient = nil
            self.internet = false
            let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString("\(AppError.noInternetConnection.description)", comment: "")]
            let error = NSError(domain: ErrorDomain,code:AppError.weatherInfoUnavailable.rawValue,userInfo: userInfo)
            self.weatherAppError = error
        }
    }
}//end of extension
