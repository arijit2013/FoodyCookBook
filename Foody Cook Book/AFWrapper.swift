//
//  AFWrapper.swift
//  Zero OCD
//
//  Created by Arijit Das on 14/06/20.
//  Copyright © 2020 yuwee. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class AFWrapper: NSObject {

    static let sharedInstance = AFWrapper()
    
    private var manager: Session? = {
        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 20
//        configuration.timeoutIntervalForResource = 20
        let alamoFireManager = Session(configuration: configuration)
        return alamoFireManager
    }()

    //TODO :-
    /* Handle Time out request alamofire */

    func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void)
    {
        manager!.request(strURL).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if (responseObject.value != nil) {
                let resJson = JSON(responseObject.value!)
                success(resJson)
            } else {
                let error : Error = responseObject.error!
                failure(error)
            }
//            if responseObject.result.isSuccess {
//                let resJson = JSON(responseObject.result.value!)
//                //let title = resJson["title"].string
//                //print(title!)
//                success(resJson)
//            }
//
//            if responseObject.result.isFailure {
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
        }
    }
    
    func requestGETURLWithHeader(_ strURL: String, headers : HTTPHeaders?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        manager!.request(strURL, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if (responseObject.value != nil) {
                let resJson = JSON(responseObject.value!)
                success(resJson)
            } else {
                let error : Error = responseObject.error!
                failure(error)
            }
        }
    }

    func requestPOSTURL(_ strURL : String, params : [String : Any]?, headers : HTTPHeaders?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        manager!.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if (responseObject.value != nil) {
                let resJson = JSON(responseObject.value!)
                success(resJson)
            } else {
                let error : Error = responseObject.error!
                failure(error)
            }
        }
    }
    
    func requestPOSTURLWithDataAndRawJson(_ strURL : String, postData : Data?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        var request = URLRequest(url: URL(string: strURL)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        manager!.request(request).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if (responseObject.value != nil) {
                let resJson = JSON(responseObject.value!)
                success(resJson)
            } else {
                let error : Error = responseObject.error!
                failure(error)
            }
        }
    }
    
    func requestPOSTURLWithData(_ strURL : String, postData : Data?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){

        var request = URLRequest(url: URL(string: strURL)!,timeoutInterval: Double.infinity)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = postData
        
        manager!.request(request).responseJSON { (responseObject) -> Void in
            if (responseObject.value != nil) {
                let resJson = JSON(responseObject.value!)
                success(resJson)
            } else {
                let error : Error = responseObject.error!
                failure(error)
            }
        }
    }
    
    func requestPUTURLWithData(_ strURL : String, postData : Data?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){

        var request = URLRequest(url: URL(string: strURL)!,timeoutInterval: Double.infinity)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "PUT"
        request.httpBody = postData
        
        manager!.request(request).responseJSON { (responseObject) -> Void in
            if (responseObject.value != nil) {
                let resJson = JSON(responseObject.value!)
                success(resJson)
            } else {
                let error : Error = responseObject.error!
                failure(error)
            }
        }
    }
    
    func requestGETURLWithData(_ strURL : String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){

        var request = URLRequest(url: URL(string: strURL)!,timeoutInterval: Double.infinity)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "GET"
        
        manager!.request(request).responseJSON { (responseObject) -> Void in
            if (responseObject.value != nil) {
                let resJson = JSON(responseObject.value!)
                success(resJson)
            } else {
                let error : Error = responseObject.error!
                failure(error)
            }
        }
    }
    
    func requestPUTURL(_ strURL : String, params : [String : Any]?, headers : HTTPHeaders?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        manager!.request(strURL, method: .put, parameters: params, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if (responseObject.value != nil) {
                let resJson = JSON(responseObject.value!)
                success(resJson)
            } else {
                let error : Error = responseObject.error!
                failure(error)
            }
        }
    }
}
