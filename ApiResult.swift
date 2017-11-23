//
//  ApiResult.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/28/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

import Foundation

enum ApiResult<T>{
    case success(T)
    case failure(Error)
 
}
