//
//  dailyTableViewCell.swift
//  AppWeather
//
//  Created by Usha Natarajan on 9/14/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

import UIKit

class dailyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var highLowLabel: UILabel!
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var weekImageView: UIImageView!
    @IBOutlet weak var sunriseDataLabel: UILabel!
    @IBOutlet weak var sunsetDataLabel: UILabel!
    @IBOutlet weak var humidityDataLabel: UILabel!
    @IBOutlet weak var precipitationTypeLabel: UILabel!
    @IBOutlet weak var chanceDataLabel: UILabel!
    @IBOutlet weak var precipitationDataLabel: UILabel!
    @IBOutlet weak var windDataLabel: UILabel!
    @IBOutlet weak var uvIndexDataLabel: UILabel!
    @IBOutlet weak var visibilityDataLabel: UILabel!
    @IBOutlet weak var dailySummaryLabel: UILabel!
    
    var dailyWeather:Daily!{
            didSet{
                updateUI()
            }
        }
        
        func updateUI(){
            DispatchQueue.main.async{
                self.dayOfTheWeekLabel.text = self.dailyWeather.dayOfTheWeek
                self.weekImageView.image = self.dailyWeather.weatherIcon.weatherIcon
                self.highLowLabel.text = "\(self.dailyWeather.temperatureHigh)  \(self.dailyWeather.temperatureLow)"
                self.sunriseDataLabel.text = self.dailyWeather.sunRise
                self.sunsetDataLabel.text = self.dailyWeather.sunSet
                self.humidityDataLabel.text = self.dailyWeather.humidity
                self.precipitationTypeLabel.text = self.dailyWeather.precipitationType
                self.chanceDataLabel.text = self.dailyWeather.precipitationChance
                self.precipitationDataLabel.text = self.dailyWeather.precipitationIntensity
                self.windDataLabel.text = self.dailyWeather.wind
                self.uvIndexDataLabel.text = self.dailyWeather.uvIndex
                self.visibilityDataLabel.text = self.dailyWeather.visibility
                self.dailySummaryLabel.text = self.dailyWeather.summary
                
            }
        }//end of function updateUI
}

//For later enhancement to include eclipse data add this to updateUI function
/*if let _  = self.dailyWeather.weatherEvent{
 self.weatherEventImage.image = self.dailyWeather.weatherEvent?.eventIcon
 }else{
 self.weatherEventImage.image = nil
 }*/
