//
//  APIRequestManager.swift
//  NASAAPOD
//
//  Created by Madushani Lekam Wasam Liyanage on 11/5/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import Foundation

class APIRequestManager {
    
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endPoint: String, callBack: @escaping (Data?) -> Void) {
        
        guard let myURL = URL(string: endPoint) else {return}
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL){(data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Error durring session: \(error)")
            }
            
            guard let validData = data else {return}
            
            callBack(validData)
            
            }.resume()
    }
    
    func postRequest(from endPoint: String, data: [String:Any]) {
        
        guard let url = URL(string: endPoint) else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // this is specifically for the midterm  -- don't change if you want to write there
        request.addValue("Basic a2V5LTE6dHdwTFZPdm5IbEc2ajFBZndKOWI=", forHTTPHeaderField: "Authorization")
        do {
            let postData = try JSONSerialization.data(withJSONObject: data, options: [])
            request.httpBody = postData
            
        }
        catch {
            print("Error \(error)")
        }
        
        //create a new session
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // this is slightly different: we use dataTask(with: URLRequest) instead of dataTask(with: URL)
        session.dataTask(with: request) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            
            if error != nil {
                print(error!)
            }
            
            if urlResponse != nil {
                print("Response: \(urlResponse!)")
            }
            
            if data != nil {
                
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    
                    if let validJson = jsonData {
                        print(validJson)
                    }
                    
                } catch {
                    print("error response \(error)")
                }
            }
            }.resume()
    }
    
}
