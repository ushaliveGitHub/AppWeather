//
//  darkSkyClient.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/27/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

//MARK: Darksky Api client
import Foundation

class DarkSkyClient{
    var ApiKey:String
    let baseURLPath = "https://api.darksky.net/forecast/"
    var endPoint:String = ""
    
    init(ApiKey: String){
        self.ApiKey = ApiKey
    }// end init
    
    func fetchWeatherFor(coordinate:Coordinate,completion:@escaping(ApiResult<LocationWeather>)->Void){
        endPoint.append(baseURLPath)
        endPoint.append(self.ApiKey)
        endPoint.append("/")

        let forecastURL = URL(string: endPoint)
        let url = URL(string: "\(coordinate.latitude!),\(coordinate.longitude!)", relativeTo: forecastURL)

        let getData = GetData(request: URLRequest(url: url!))//create urlRequest Object
        getData.downloadJSON{(json,httpResponse,error) in
            DispatchQueue.main.async{
                guard  let _  = json,
                let _  = json?["currently"] as? [String : Any],
                let locationWeather = LocationWeather(json: json!)else{
                        let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString("\(AppError.weatherInfoUnavailable.description)", comment: "")]
                        let error = NSError(domain: ErrorDomain,code:AppError.weatherInfoUnavailable.rawValue,userInfo: userInfo)
                        completion(.failure(error))
                        return
                }
                completion(.success(locationWeather))
                return
            }
        }
    }//end of fetchWeatherFor
}

