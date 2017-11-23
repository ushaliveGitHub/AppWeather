//
//  weatherCollectionView.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 10/31/17.
//

import Foundation
import UIKit
//MARK: Collection View delegate and data source
extension WeatherViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func didExpandCell(row:IndexPath){
        self.isExpanded = !self.isExpanded
        self.weatherTableView.reloadRows(at: [row], with: .fade)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let  _ = locationWeather else{
            return 0
        }
        return 26
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.hourlyCell, for: indexPath) as! hourlyCollectionViewCell
        hourlyCell.byTheHour = self.locationWeather?.byTheHour[indexPath.row]
        return hourlyCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = self.selectedIndex {
            if (self.selectedIndex!) != indexPath{
                self.isExpanded = false
                self.selectedIndex = indexPath
            }
            self.didExpandCell(row: selectedIndex!)
        }else{//user selects fot the first time.
            self.selectedIndex = indexPath
            self.didExpandCell(row: self.selectedIndex!)
        }
    }//end of didSelectRowAt
}//end of extension for Collection View
