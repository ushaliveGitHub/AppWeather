//
//  Coordinate.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/27/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//
// MARK: location coordinates 
import Foundation

struct Coordinate: CustomStringConvertible{
    var latitude:Double?
    var longitude:Double?
    
    var description: String{
        return "\(latitude!),\(longitude!)"
    }
   static func ==(_ left:Coordinate,_ right:Coordinate)->Bool {
       return (left.latitude == right.latitude) && (left.longitude == right.longitude)
    }//end of func ==
}
