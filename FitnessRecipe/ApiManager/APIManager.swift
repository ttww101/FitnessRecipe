//
//  APIManager.swift
//  FitnessRecipe
//
//  Created by Apple on 5/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

struct APIError: Error {
    var desc = ""
    var localizedDescription: String {
        return desc
    }
    init(_ desc: String) {
        self.desc = desc
    }
}

class APIManager: NSObject {
    
    static let shared = APIManager()
    
    let apiError = APIError("查无资料")
    
    func getData(url: String, parameter: [String:String], completion: @escaping(AnyObject) -> Void, error: @escaping(Error) -> Void) {
        guard let url = URL(string: url + parameterToString(parameter)) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, errorMessage) in
            if errorMessage != nil {
                error(errorMessage!)
            } else {
                DispatchQueue.main.async(execute: {
                    if data != nil {
                        do {
                            let json: AnyObject = try JSONSerialization.jsonObject(with: data!, options: []) as! AnyObject
                            completion(json)
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    } else {
                        error(self.apiError)
                    }
                })
            }
            }.resume()
    }
    
    private func parameterToString(_ parameter: [String:String]) -> String {
        var s = "?"
        for (key, value) in parameter {
            s += "\(key)=\(value)&"
        }
        s.remove(at: s.index(before: s.endIndex))
        return s
    }
}

