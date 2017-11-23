//
//  getData.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/27/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

//MARK: download data as json in url session from api 
import Foundation

class GetData{
    let request:URLRequest
    
    lazy var configuration:URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    typealias JSON = [String : Any]
    typealias JSONHandler = (JSON?, HTTPURLResponse?, Error?)->Void
    
    init(request:URLRequest){
        self.request = request
    }//end of init
    
    func downloadJSON(completion: @escaping JSONHandler)->Void{
        
        let dataTask = session.dataTask(with:request){
            (data,response,error) in //completion handler
            
            //On httpError!
            guard let httpResponse = response as? HTTPURLResponse else{
                let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString(AppError.missingHttpResponseError.description, comment: "")]
                let error = NSError(domain:ErrorDomain,code:AppError.missingHttpResponseError.rawValue,userInfo:userInfo)
                completion(nil,nil,error as Error)
                return
            }
            //On Data not found!
            if data == nil{
                if let error = error{
                    completion(nil,httpResponse,error as Error)
                }
            }else{
                switch httpResponse.statusCode{
                case 200,404: //sucess!
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                        completion(jsonData,httpResponse,nil)
                    }catch let error as NSError{//bad data
                        completion(nil,httpResponse,error)
                       }
                default://other errors!
                    print("Received http Response Error code:\(httpResponse.statusCode)")
                }
            }
        }
        dataTask.resume()
    }//end of downloadJSON
    
}//end of class GetData
