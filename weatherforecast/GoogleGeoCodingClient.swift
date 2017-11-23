//
//  GoogleGeoCodingClient.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/29/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//
// MARK: google geocoding api client
import Foundation

class GoogleGeoCodingClient{
    var googleApiKey: String!
    init(googleApiKey:String){
            self.googleApiKey = googleApiKey
    }
    
    func fetchLocationFor(coordinate:Coordinate,completion:@escaping(ApiResult<LocationName>)->Void){
        
        let searchEndPoint = GoogleGeoCodeEndpoint.search(googleApiKey: self.googleApiKey!,coordinate:coordinate)
    
        let getData = GetData(request: searchEndPoint.request)

        getData.downloadJSON{ (json,httpResponse,error) in
            DispatchQueue.main.async{
                guard let _ = json,
                let locationResults = json?["results"] as? [[String: Any]],
                let components = locationResults.first,
                let addressComponents = components["address_components"] as? [[String:Any]],
                let locationName = LocationName(json: addressComponents,coordinate:coordinate)else{
                    let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString("\(AppError.locationDataUnavailable.description) \(AppError.noInternetConnection.description)", comment: "")]
                    let error = NSError(domain:ErrorDomain, code: AppError.locationDataUnavailable.rawValue,userInfo:userInfo)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(locationName))
            }
        }
    }//end of fetchLocationFor
    
    func fetchSearchResultsFor(input:String,completion:@escaping(ApiResult<[LocationIDs]>)->Void){
        let searchEndPoint = GoogleLocationEndpoint.search(googleApiKey: self.googleApiKey!,input:input)
        let getData = GetData(request: searchEndPoint.request)
        
        getData.downloadJSON{ (json,httpResponse,error) in
            DispatchQueue.main.async{
                guard let _ = json,
                    let locationResults = json?["predictions"] as? [[String: Any]]
                    else{
                        let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString("\(AppError.locationDataUnavailable.description) \(AppError.noInternetConnection.description)", comment: "")]
                        let error = NSError(domain:ErrorDomain, code: AppError.locationDataUnavailable.rawValue,userInfo:userInfo)
                        completion(.failure(error))
                        return
                }
                let locationIDs = locationResults.flatMap { locationResult in
                    return LocationIDs(json: locationResult) // a locationAddress object
                }
                completion(.success(locationIDs))
            }
        }
    }//end of fetchSearchResultsFor
    
    func fetchLocationByID(locationID:LocationIDs,completion:@escaping(ApiResult<LocationAddress>)->Void){
        print(locationID.uniqueLocationID)
        let searchEndPoint = GoogleGeoCodeEndpoint.searchByID(googleApiKey: self.googleApiKey!,locationID:locationID.uniqueLocationID)
        
        let getData = GetData(request: searchEndPoint.request)
        
        getData.downloadJSON{ (json,httpResponse,error) in
            DispatchQueue.main.async{
                guard let _ = json,
                    let locationResults = json?["results"] as? [[String: Any]],
                    let components = locationResults.first,
                    let locationAddress = LocationAddress(json: components)else{
                        let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString("\(AppError.locationDataUnavailable.description) \(AppError.noInternetConnection.description)", comment: "")]
                        let error = NSError(domain:ErrorDomain, code: AppError.locationDataUnavailable.rawValue,userInfo:userInfo)
                        completion(.failure(error))
                        return
                }
                
                completion(.success(locationAddress))
            }
        }
    }//end of fetchLocationFor
    
    
}
