//
//  weatherTableView.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 10/31/17.
//

import Foundation
import UIKit

//MARK: tableview delegate and datasource
extension WeatherViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return Storyboard.week
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = locationWeather else{
            return 0
        }
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isExpanded && self.selectedIndex == indexPath {
            return 275
        }
        return 45
    }//end of heightForRowAtIndex
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dailyCell = tableView.dequeueReusableCell(withIdentifier: Storyboard.dailyCell, for: indexPath) as! dailyTableViewCell
        dailyCell.dailyWeather = self.locationWeather?.weeklyForecast[indexPath.row]
        return dailyCell
        
    }//end of cellForRowAt
    
}//end  of extension
