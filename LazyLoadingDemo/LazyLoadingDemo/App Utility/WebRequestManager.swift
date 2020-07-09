//
//  WebRequestManager.swift
//  Field-O
//
//  Created by Hardik Pithadia on 12/01/19.
//  Copyright © 2019 Hardik Pithadia. All rights reserved.
//

import UIKit

class WebRequestManager: NSObject
{
    class func parseJsonWebService(urlString : String, parameters : [String : String] ,completionHandlor:@escaping(Bool, AnyObject) -> ())
    {
        print("URL : \(urlString)")
        print("Parameters : \(parameters)")
        
        let myURL = URL(string: urlString)
                
        //set the Request
        var urlRequest = URLRequest(url: myURL!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
//        if parameters != nil
//        {
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
//        }
        
        urlRequest.timeoutInterval = 60
        
        let session = URLSession.shared
        
        let dataTast = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if response != nil
            {
                let httpStatusCode = response as! HTTPURLResponse
                let statusCode = httpStatusCode.statusCode
                
                if statusCode == 200
                {
                    do {
                        let jsonResponse = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers))
                        
                        completionHandlor(true, jsonResponse as AnyObject)
                        
                    } catch {
                        print("Catch Block Executed")
                    }
                }
                else
                {
                    completionHandlor(false, [] as AnyObject)
                }
            }
            else
            {
                completionHandlor(false, [] as AnyObject)
            }
        }
        
        dataTast.resume()
    }
    
    class func parseJsonWebServiceGet(urlString : String ,completionHandlor:@escaping(Bool, AnyObject) -> ())
        {
            print("URL : \(urlString)")
            
            let myURL = URL(string: urlString)
                    
            //set the Request
            var urlRequest = URLRequest(url: myURL!)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue(Constants.HEADER_VALUE, forHTTPHeaderField: "x-api-key")
            
            urlRequest.timeoutInterval = 60
            
            let session = URLSession.shared
            
            let dataTast = session.dataTask(with: urlRequest) { (data, response, error) in
                
                if response != nil
                {
                    let httpStatusCode = response as! HTTPURLResponse
                    let statusCode = httpStatusCode.statusCode
                    
                    if statusCode == 200
                    {
                        do {
                            let jsonResponse = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers))
                            
                            completionHandlor(true, jsonResponse as AnyObject)
                            
                        } catch {
                            print("Catch Block Executed")
                        }
                    }
                    else
                    {
                        completionHandlor(false, [] as AnyObject)
                    }
                }
                else
                {
                    completionHandlor(false, [] as AnyObject)
                }
            }
            
            dataTast.resume()
        }
}
