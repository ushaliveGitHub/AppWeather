//
//  weatherIcon.swift
//  AppWeather
//
//  Created by Usha Natarajan on 9/8/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

//MARK: Weather Conditions
import Foundation
import UIKit

enum Weather:String{
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case rain = "rain"
    case rainDay = "rainDay"
    case rainNight = "rainNight"
    case snow = "snow"
    case snowDay = "snowDay"
    case snowNight = "snowNight"
    case sleet = "sleet"
    case wind = "wind"
    case windyWithRain = "windy-with-rain"
    case fog = "fog"
    case fogDay = "fogDay"
    case fogNight = "fogNight"
    case cloudy = "cloudy"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case hail = "hail"
    case thunderstorm = "thunderstorm"
    case thunderstormDay = "thunderstormDay"
    case thunderstormNight = "thunderStormNight"
    case tornado = "tornado"
    case sunRise = "sunrise"
    case sunSet = "sunset"
    case fullMoon = "fullMoon"
    case newMoon = "newMoon"
    
    var weatherIcon:UIImage{
        switch self{
            case .clearDay:
                return UIImage(named:"clearDay")!
            case .clearNight:
                return UIImage(named:"clearNight")!
            case .rain:
                return UIImage(named:"rain")!
            case .rainDay:
                return UIImage(named:"rainDay")!
            case .rainNight:
                return UIImage(named:"rainNight")!
            case .snow:
                return UIImage(named:"snow")!
            case .snowDay:
                return UIImage(named:"snowDay")!
            case .snowNight:
                return UIImage(named:"snowNight")!
            case .sleet:
                return UIImage(named:"sleet")!
            case .wind:
                return UIImage(named:"wind")!
            case .windyWithRain:
                return UIImage(named:"windyWithRain")!
            case .fogDay:
                return UIImage(named:"fogDay")!
            case .fogNight:
                return UIImage(named: "fogNight")!
            case .cloudy:
                return UIImage(named:"cloudy")!
            case .partlyCloudyDay:
                return UIImage(named:"partlyCloudyDay")!
            case .partlyCloudyNight:
                return UIImage(named:"partlyCloudyNight")!
            case .hail:
                return UIImage(named:"hail")!
            case .thunderstorm:
                return UIImage(named:"thunderstorm")!
            case .thunderstormDay:
                return UIImage(named:"thunderstormDay")!
            case .thunderstormNight:
                return UIImage(named:"thunderstormNight")!
            case .tornado:
                return UIImage(named:"tornado")!
            case .sunRise:
                return UIImage(named:"sunRise")!
            case .sunSet:
                return UIImage(named: "sunSet")!
            case .newMoon:
                return UIImage(named: "newMoon")!
            case .fullMoon:
                return UIImage(named: "fullMoon")!
            default:
                return UIImage(named: "NA")!
        }
    }
    var weatherImage:UIImage{
        switch self{
        case .clearDay:
            return UIImage(named:"clearDayImage")!
        case .clearNight:
            return UIImage(named:"clearNightImage")!
        case .rain,.rainDay,.rainNight:
            return UIImage(named:"heavyRainImage")!
        case .snow,.snowDay,.snowNight:
            return UIImage(named:"snowImage")!
        case .sleet:
            return UIImage(named:"sleetImage")!
        case .wind:
            return UIImage(named:"windyImage")!
        case .windyWithRain:
            return UIImage(named: "windyWithRainImage")!
        case .fog,.fogDay,.fogNight:
            return UIImage(named:"fogImage")!
        case .cloudy:
            return UIImage(named:"cloudyImage")!
        case .partlyCloudyDay:
            return UIImage(named:"partlyCloudyDayImage")!
        case .partlyCloudyNight:
            return UIImage(named:"partlyCloudyNightImage")!
        case .hail:
            return UIImage(named:"hailImage")!
        case .thunderstorm,.thunderstormDay,.thunderstormNight:
            return UIImage(named:"thurderstormImage")!
        case .tornado:
            return UIImage(named:"tornadoImage")!
        default:
            return UIImage(named: "blank")!
        }
    }

}
