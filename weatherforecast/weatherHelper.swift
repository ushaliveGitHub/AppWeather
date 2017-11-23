//
//  weatherHelper.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 10/5/17.
//

import Foundation

//get day of the week based on timeZone
func dayOfTheWeek(time:Double,zone:String?) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeZone = TimeZone(identifier:zone!)
    let date = dateFormatter.string(from:(NSDate(timeIntervalSince1970: time)) as Date)
    return  date.components(separatedBy: ",").first!
}

//Convert to required timeformat for forecast
func convertToTime(format:String,time:Double,zone:String?) -> String{
    let dateFormatter = DateFormatter()
    if let _ = zone{
        dateFormatter.timeZone = TimeZone(identifier:zone!)
    }
    dateFormatter.dateFormat = format
    let date = dateFormatter.string(from:NSDate(timeIntervalSince1970: time) as Date)
    
    let dateComponents = date.components(separatedBy: " ")
    let length = dateComponents.count
    let timeComponent = dateComponents[length - 2]
    let timeComponents = timeComponent.components(separatedBy:":")
    var formattedTime = String(describing:Int(timeComponents.first!)!)
    
    if timeComponents.count > 1{
        formattedTime = formattedTime +  ":" + String(describing:timeComponents.last!)
    }
    let formattedDate:String = formattedTime + " " + dateComponents[length - 1]
    return formattedDate
}//end of convertToTime


//Calculate cardinal wind direction from wind bearing degrees
func windDirection(degree: Int, speed:Double) -> String {
    let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE","S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    let i = Int((Double(degree) + 11.25) / 22.5)
    let direction = directions[i % 16]
    return direction + " " + String(format: "%.2f", speed) + " mph"
}//end of windDirection

//To calculate weather related eventDate
func isEventDate(time:String, format:String)-> Bool{
    let formatter = DateFormatter()
    formatter.dateFormat = format
    let calendar = Calendar.current
    let stringTime = "\(time),\(calendar.component(.year, from:Date()))"
    let convertedDate = formatter.date(from: stringTime)
    
    return calendar.isDate(convertedDate!, inSameDayAs: Date())
}

// To determine special weather/astronomy related events
func getWeatherEvent()-> WeatherEvent?{
    //For lunar and solar eclipse enchancement
    /*let events = [ WeatherEvent.eclipseLunar,
                   WeatherEvent.eclipseSolar
        ]*/
    return nil
}//end of getWeatherEvent

//Is it night time in location?
func isItNight(zone:String?,sunSet:Double,sunRise:Double,zoneTime:Double? = nil) -> Bool{
    let current = (zoneTime == nil) ? 0.0 : zoneTime!
    if current > sunSet{
        return true
    }else if current < sunRise{
        return true
    }
    return false
}
