//
//  ApiManager.swift
//  Traffic Camera
//
//  Created by Arijit Das on 15/02/21.
//

import UIKit
import Alamofire
import Foundation

class ApiManager: NSObject {
    
    static let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    
    static var sharedInstance = ApiManager()
    
    func getRandomMealDetails(firstLetter: String, completionHandler: @escaping (_ Result: AnyObject?, _ Error: Error?) -> Void) {
        
        let URL = ApiManager.baseURL + "search.php?f=" + firstLetter
        
        AFWrapper.sharedInstance.requestGETURL(URL, success: { (response) in
            completionHandler(response.dictionaryObject! as AnyObject, nil)
        }) { (error) in
            completionHandler(nil, error)
        }
    }
    
    func getSearchMealDetails(mealName: String, completionHandler: @escaping (_ Result: AnyObject?, _ Error: Error?) -> Void) {
        
        let URL = ApiManager.baseURL + "search.php?s=" + mealName
        
        AFWrapper.sharedInstance.requestGETURL(URL, success: { (response) in
            completionHandler(response.dictionaryObject! as AnyObject, nil)
        }) { (error) in
            completionHandler(nil, error)
        }
    }
}
