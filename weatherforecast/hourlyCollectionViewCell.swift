//
//  hourlyCollectionViewCell.swift
//  AppWeather
//
//  Created by Usha Natarajan on 9/14/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

import UIKit

class hourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    
    var byTheHour:hourly!{
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        DispatchQueue.main.async{
            self.timeLabel.text = self.byTheHour.time
            self.precipitationLabel.text =  self.byTheHour.precipitationChance
            self.temparatureLabel.text =   self.byTheHour.temperature
            self.weatherIconView.image = self.byTheHour.weatherIcon.weatherIcon
        }
    }//end of updateUI()
}
