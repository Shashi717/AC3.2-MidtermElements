//
//  Element.swift
//  AC3.2-MidtermElements
//
//  Created by Madushani Lekam Wasam Liyanage on 12/8/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import Foundation

enum ElementsModelParseError: Error {
    case results(json: Any)
}

class Element {
    
    /*
     {
     "id": 1,
     "record_url": "https://fieldbook.com/records/5848deac37802c0400b17c6b",
     "number": 1,
     "weight": 1.0079,
     "name": "Hydrogen",
     "symbol": "H",
     "melting_c": -259,
     "boiling_c": -253,
     "density": 0.09,
     "crust_percent": 0.14,
     "discovery_year": "1776",
     "group": 1,
     "electrons": "1s1",
     "ion_energy": 13.5984
     }
     */
    
    let number: Int
    let weight: Double
    let name: String
    let symbol: String
    let meltingPoint: String
    let boilingPoint: String
    let discoveryYear: String
    
    
    init(number: Int, weight: Double, name: String, symbol: String, meltingPoint: String, boilingPoint: String, discoveryYear: String) {
        self.number = number
        self.weight = weight
        self.name = name
        self.symbol = symbol
        self.meltingPoint = meltingPoint
        self.boilingPoint = boilingPoint
        self.discoveryYear = discoveryYear
    }
    
    convenience init?(from dictionary: [String:AnyObject]) throws {
        
        var meltingPoint = " "
        var boilingPoint = " "
        
        let melt = nullToNil(value: dictionary["melting_c"])
        let boil = nullToNil(value: dictionary["boiling_c"])
        
        
        if let number = dictionary["number"] as? Int,
            let weight = dictionary["weight"] as? Double,
            let name = dictionary["name"] as? String,
            let symbol = dictionary["symbol"] as? String,
            let discoveryYear = dictionary["discovery_year"] as? String{
            
            if let melting = melt {
                meltingPoint = String(describing: melting)
            }
            
            if let boiling = boil {
                boilingPoint = String(describing: boiling)
            }
            self.init(number: number, weight: weight, name: name, symbol: symbol, meltingPoint: meltingPoint, boilingPoint: boilingPoint, discoveryYear: discoveryYear)
        }
            
        else {
            return nil
        }
        
    }
    
    static func getElements(from data: Data) -> [Element]? {
        var elementsToReturn: [Element]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [[String:AnyObject]] = jsonData as? [[String:AnyObject]]
                
                else {
                    throw ElementsModelParseError.results(json: jsonData)
            }
            
            for elementtDict in response {
                
                if let element = try Element(from: elementtDict) {
                    elementsToReturn?.append(element)
                }
                
            }
            
        }
            
        catch let ElementsModelParseError.results(json: json)  {
            print("Error encountered with parsing elements for object: \(json)")
        }
            
        catch {
            print("Unknown parsing error")
        }
        
        return elementsToReturn
    }
    
    
}

//http://stackoverflow.com/questions/37606376/how-to-handle-json-null-values-in-swift
func nullToNil(value: AnyObject?) -> AnyObject? {
    if value is NSNull {
        return nil
    } else {
        return value
    }
}
