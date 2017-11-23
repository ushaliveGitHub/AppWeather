//
//  LocationManager.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/27/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//
//MARK: location manager helper

import Foundation
import CoreLocation //for location Services

class LocationManager:NSObject{
    
    let manager = CLLocationManager()
    var didGetLocation:((Coordinate)->Void)?
    var didTriggerError:((Error)->Void)?
   
    
    override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }//end of init
    
    func getPermission(flag:Bool) -> Bool{ // get location service permission from user
        
        switch CLLocationManager.authorizationStatus(){
            case .notDetermined:
                manager.delegate = self
                manager.requestWhenInUseAuthorization()
                return true
            case .denied:
                return false
            case .authorizedWhenInUse:
                if flag{
                    manager.delegate = self
                    manager.startUpdatingLocation()
                }
                return true
            case .authorizedAlways:
                if flag{
                    manager.delegate = self
                    manager.startUpdatingLocation()
                }
                return  true
            case .restricted:
                return false
        }
    }//end of getPersmission
}//end of LocationManager

extension LocationManager : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways || status == .notDetermined {
                manager.requestLocation()
            }else{
            if let didTriggerError = didTriggerError {
                let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString(AppError.permissionDenied.description, comment: "")]
                let error = NSError(domain:ErrorDomain, code: AppError.permissionDenied.rawValue,userInfo:userInfo)
                didTriggerError(error)
            }
        }
    }//end of location manager with did change authorization status
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let didTriggerError = didTriggerError {
            let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString(AppError.permissionDenied.description, comment:"")]
            let error = NSError(domain:ErrorDomain, code: AppError.permissionDenied.rawValue,userInfo:userInfo)
                didTriggerError(error)
            didTriggerError(error)
        }
    }//end of didFailWithError
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else{
                return
            }
            self.manager.stopUpdatingLocation()
            let coordinate = Coordinate(location: location)
            if let didGetLocation = didGetLocation {
                didGetLocation(coordinate)
            }
    }
}//end of Location Manager extension

private extension Coordinate{
    init(location: CLLocation){
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }//end of init
}//end of Coordinate extension

