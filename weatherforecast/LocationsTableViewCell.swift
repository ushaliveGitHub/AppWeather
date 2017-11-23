//
//  LocationsTableViewCell.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 10/13/17.
//

import UIKit

class LocationsTableViewCell: UITableViewCell {

    @IBOutlet weak var locationTimeLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationTemperatureLabel: UILabel!
    
    var locationData:LocationData! {
        didSet{
           updateUI()
        }
    }
    
    func updateUI(){
        
    }
}
