//
//  weatherEvents.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 10/4/17.
//

import Foundation
import UIKit

//MARK: to determine season start, eclipse etc

enum WeatherEvent:String{
    case eclipseSolar = "eclipseSolar"
    case eclipseLunar = "eclipseLunar"
    
    var eventIcon:UIImage{
        switch self{
        case .eclipseSolar:
            return UIImage(named:"eclipseSolar")!
        case .eclipseLunar:
            return UIImage(named:"eclipseLunar")!
        }
    }
}//end of enum WeatherEvent


