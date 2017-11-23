//
//  LocationWeather.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/27/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//
//MARK: Construction the weather data from darkSky json 

import Foundation
struct hourly{
    var time:String
    var rawTime:Double
    var temperature:String = "0"
    var weatherIcon:Weather
    var precipitationChance:String = "0%"
}

/* add this line of code to struct Daily include other weather events like eclipse*/
//var weatherEvent:WeatherEvent?
struct Daily{
    var dayOfTheWeek:String
    var weatherIcon:Weather
    var temperatureHigh:String = "0"
    var temperatureLow:String = "0"
    var sunriseRaw:Double
    var sunsetRaw:Double
    var sunRise:String
    var sunSet:String
    var moonPhase:Double?
    var rawTime:Double
    var snowAccumulation:String
    var precipitationType:String
    var precipitationIntensity:String
    var precipitationChance:String
    var humidity:String
    var wind:String
    var uvIndex:String
    var visibility:String
    var summary:String
}

struct LocationWeather{
    var temperature:Double = 0.0
    var currentTime:String = ""
    var currentConditions:String?
    var weatherBackground:Weather
    var byTheHour:[hourly] = [] // hourly weather
    var weeklyForecast:[Daily] = [] //forecast for the week
    var feelsLike:String
    var summary:String //weekly weather summary
    //var detail:Detail //detailed summary of today's weather conditions
    var NA = "N/A"
    var timeZone:String? = nil 
    
    
    init?(json: [String: Any]){
        
        var newByTheHour:hourly = hourly(time: "",
                                         rawTime: 0.0,
                                         temperature: "",
                                         weatherIcon: Weather.clearDay,
                                         precipitationChance: "")
        
        var newDaily:Daily = Daily(dayOfTheWeek: "",
                                   weatherIcon: Weather.clearDay,
                                   temperatureHigh: "",
                                   temperatureLow: "",
                                   sunriseRaw: 0.0,
                                   sunsetRaw:0.0,
                                   sunRise: "",
                                   sunSet: "",
                                   moonPhase: nil,
                                   rawTime: 0.0,
                                   snowAccumulation: "",
                                   precipitationType: "",
                                   precipitationIntensity: "",
                                   precipitationChance: "",
                                   humidity: "",
                                   wind: "",
                                   uvIndex: "",
                                   visibility: "",
                                   summary: "")
        
        
//MARK: Get the timeZone
        if let timeZone = json["timezone"] as? String{
            self.timeZone = timeZone
        }
        
//MARK: Processing currently data
        guard let currently = json["currently"] as? [String:Any],
        let temperature = currently["temperature"] as? Double,
        let feelsLike = currently["apparentTemperature"] as? Double,
        let currentTime = currently["time"] as? Double,
        let icon = currently["icon"] as? String else{
                return nil
        }
            
        self.weatherBackground = Weather(rawValue:icon)!
        self.currentConditions = icon.replacingOccurrences(of:"-", with: " ")
        self.temperature = temperature
        self.currentTime = convertToTime(format: "dd-MMM-yyyy hh a", time: currentTime,zone:timeZone)
        self.feelsLike = String(feelsLike)
        
//MARK: Processing hourly data
        guard let hourlyJson = json["hourly"] as? [String:Any],
            let hourlyData = hourlyJson["data"] as? [[String:Any]] else{
                return nil
        }
        
        for hour in hourlyData{
            guard let time = hour["time"] as? Double,
            let weatherIcon = hour["icon"] as? String,
            let temperature = hour["temperature"] as? Double,
                let precipitationChance = hour["precipProbability"] as? Double else{
                    return nil
            }
            
            // Time Calculation
            newByTheHour.time = convertToTime(format: "dd-MMM-yyyy hh a", time: time,zone:timeZone)
            newByTheHour.rawTime = time
            newByTheHour.weatherIcon =  Weather(rawValue:weatherIcon)!
            newByTheHour.temperature = String(format: "%.0f",temperature)
            if Weather(rawValue: weatherIcon) == Weather.windyWithRain ||
                Weather(rawValue: weatherIcon) == Weather.rain ||
                Weather(rawValue: weatherIcon) == Weather.sleet ||
                Weather(rawValue: weatherIcon) == Weather.snow ||
                Weather(rawValue: weatherIcon) == Weather.hail {
                newByTheHour.precipitationChance = "\(Int(precipitationChance * 100))%"
            }else{
                newByTheHour.precipitationChance = " "
            }
            self.byTheHour.append(newByTheHour)
        }
        self.byTheHour[0].time = "Now"
        
//MARK: Processing weekly forecast Data
        
        guard let dailyJson = json["daily"] as? [String:Any],
            let dailyData = dailyJson["data"] as? [[String:Any]] else{
                return nil
        }
        
        for day in dailyData{
            guard let time = day["time"] as? Double,
            let weatherIcon = day["icon"] as? String,
            let dailySunRise = day["sunriseTime"] as? Double,
            let dailySunSet = day["sunsetTime"] as? Double,
            let temperatureHigh = day["temperatureHigh"] as? Double,
            let temperatureLow = day["temperatureLow"] as? Double,
            let precipitationIntensity = day["precipIntensityMax"] as? Double,
            let precipitationProbability = day["precipProbability"] as? Double,
            let humidity = day["humidity"] as? Double,
            let windBearing = day["windBearing"] as? Int,
            let windSpeed = day["windSpeed"] as? Double,
            let uvIndex = day["uvIndex"] as? Int,
            let uvIndexTime = day["uvIndexTime"] as? Double,
            let summary = day["summary"] as? String else{
                    return nil
            }
            //get precipitation type
            if let precipitationType = day["precipType"] as? String {
                newDaily.precipitationType = "Chance of \(precipitationType):"
            }else{
                newDaily.precipitationType = "Chance of rain:"
            }
            
            //get the moonPhase
            if let moonPhase = day["moonPhase"] as? Double{
                newDaily.moonPhase = moonPhase
            }
            
            //For snow accumulation Optional
            if let snowAccumulation = day["precipAccumulation"] as? Double{
                newDaily.snowAccumulation = String(format: "%.2f",snowAccumulation) + " in"
            }
            //For visibility optional?(during night)
            if let visibility = day["visibility"] as? Int {
                newDaily.visibility = String(visibility) + " mi"
            }else{
                newDaily.visibility = NA
            }
            
            //Fill weekly data
            newDaily.dayOfTheWeek = dayOfTheWeek(time: time, zone: self.timeZone)
            newDaily.rawTime = time
            //newDaily.weatherIcon =  Weather(rawValue:weatherIcon)!
            newDaily.temperatureHigh = String(format:"%.0f",temperatureHigh)
            newDaily.temperatureLow = String(format:"%.0f",temperatureLow)
            newDaily.sunriseRaw = dailySunRise
            newDaily.sunsetRaw =  dailySunSet
            newDaily.summary = summary
            newDaily.humidity = String(format: "%.0f",(humidity * 100)) + "%"
            newDaily.precipitationChance = String(format: "%.0f",(precipitationProbability * 100)) + "%"
            newDaily.uvIndex = String(uvIndex) + " at " + convertToTime(format: "dd-MMM-yyyy hh a", time: uvIndexTime,zone:timeZone)
            
            
            //For weather Icon
            newDaily.weatherIcon = getIcon(weather:Weather(rawValue:weatherIcon)!,sunSet:dailySunSet,sunRise:dailySunRise,zone:self.timeZone!,zoneTime:newDaily.rawTime)
    
            // Convert sunrise and sunset to ate 
            newDaily.sunRise = convertToTime(format:"dd-MMM-yyyy hh:mm a" , time:newDaily.sunriseRaw ,zone:timeZone)
            newDaily.sunSet = convertToTime(format:"dd-MMM-yyyy hh:mm a" , time:newDaily.sunsetRaw ,zone:timeZone)
            
            //For Rain - Optional
            if precipitationIntensity >= 0.01{
                newDaily.precipitationIntensity = String(format: "%.2f",precipitationIntensity) + " in"
            }else{
                newDaily.precipitationIntensity = "N/A"
            }
            
            //Wind calculation
            newDaily.wind = windDirection(degree:windBearing, speed:windSpeed)
            
            self.weeklyForecast.append(newDaily)
        }
        self.weeklyForecast[0].dayOfTheWeek = "Today"
        
//MARK: Processing weekly Weather Summary data
        guard let summary = dailyJson["summary"] as? String else{
            return nil
        }
        self.summary = summary
        
// add feels like for today
        self.weeklyForecast[0].summary = "Currently feels like \(self.feelsLike).\(self.weeklyForecast[0].summary)"
        
//Determine if tonight is newMoon or fullMoon
        if isItNight(zone:self.timeZone,sunSet:self.weeklyForecast[0].sunsetRaw,
                     sunRise:self.weeklyForecast[0].sunriseRaw,zoneTime: self.weeklyForecast[0].rawTime){
            self.weeklyForecast[0].weatherIcon = getMoonPhase(day:self.weeklyForecast[0])
        }
        
//Determine the weather icon for hourly
        for i in 0...(byTheHour.count - 1){
            byTheHour[i].weatherIcon = getIcon(weather: byTheHour[i].weatherIcon, sunSet:weeklyForecast[0].sunsetRaw,sunRise:weeklyForecast[0].sunriseRaw,zone:timeZone!,zoneTime: byTheHour[i].rawTime)
            
        }
                
//MARK: Insert the Sunrise and Sunset in hourly weather forecast
        var sunRiseSet = false
        var sunSetSet = false
        
        for day in weeklyForecast{
            for hour in byTheHour{
                if day.sunriseRaw > hour.rawTime && !sunRiseSet{
                    
                    newByTheHour.time = convertToTime(format:"dd-MMM-yyyy hh:mm a" , time: day.sunriseRaw,zone:timeZone)
                    newByTheHour.rawTime = day.sunriseRaw
                    newByTheHour.weatherIcon = Weather.sunRise
                    newByTheHour.temperature = "Sunrise"
                    newByTheHour.precipitationChance = ""
                    byTheHour.append(newByTheHour)
                    sunRiseSet = true
                }
                if day.sunsetRaw > hour.rawTime && !sunSetSet {
                    newByTheHour.time = convertToTime(format:"dd-MMM-yyyy hh:mm a" , time: day.sunsetRaw,zone:timeZone)
                    newByTheHour.rawTime = day.sunsetRaw
                    newByTheHour.weatherIcon = Weather.sunSet
                    newByTheHour.temperature = "Sunset"
                    newByTheHour.precipitationChance = ""
                    byTheHour.append(newByTheHour)
                    sunSetSet = true
                }
            }
            if sunRiseSet && sunSetSet{
               break
            }
        }
        byTheHour.sort(by: {$0.rawTime < $1.rawTime}) //asceding order
        
//MARK: Processing optional alerts data
        /*guard let alertsJson = json["alerts"] as? [String:Any],
            let alertTitle = alertsJson["title"] as? String,
            let issuedAt = alertsJson["time"] as? Double,
            let expiresAt = alertsJson["expires"] as? Double else{
                return
        }*/
    }//end of failable init
    
    
}//end of struct locationWeather

func getIcon(weather:Weather,sunSet:Double,sunRise:Double,zone:String,zoneTime:Double) -> Weather{
    switch weather{
    case .fog:
        if isItNight(zone:zone,sunSet:sunSet,sunRise:sunRise,zoneTime:zoneTime){
            return  Weather.fogNight
        }else{
            return  Weather.fogDay
        }
    /*case .rain:
         if isItNight(zone:zone,sunSet:sunSet,sunRise:sunRise,zoneTime:zoneTime){
            return Weather.rainNight
         }else{
            return Weather.rainDay
        }*/
    case .thunderstorm:
        if isItNight(zone:zone,sunSet:sunSet,sunRise:sunRise,zoneTime:zoneTime){
            return Weather.thunderstormNight
        }else{
            return Weather.thunderstormDay
        }
    case .snow:
        if isItNight(zone:zone,sunSet:sunSet,sunRise:sunRise,zoneTime:zoneTime){
            return Weather.snowNight
        }else{
            return Weather.snowDay
        }
    default:
        return weather
    }
}//end of getIcon

func getMoonPhase(day:Daily)->Weather{
    if day.moonPhase == 0.0 {
        return Weather.newMoon
    }else if day.moonPhase! >= 0.46 && day.moonPhase! <= 0.54{
        return Weather.fullMoon
    }
    return day.weatherIcon
}//end of get moonPhase


