//
//  FitnessRecipeData.swift
//  FitnessRecipe
//
//  Created by Apple on 5/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

struct FRData {
    static var url = "http://47.75.131.189/4716686ae308dfacacea2ed413f869ad/"
    static var collection = [String]()
    static var fitness = [String]()
    static var userData = [String:[String:[String]]]()
    static var height: Double = 0
    static var weight: Double = 0
}
struct userAccount {
    static var account = ""
}

class DataControl {
    let userDefault = UserDefaults.standard
    let healthManager:HealthKitManager = HealthKitManager()
    
    init() {
        setDefault()
        healthManager.authorizeHealthKit { (authorized, error) in
            if authorized {
                print("healthkit success")
            } else {
                if error != nil {
                    print(error)
                }
            }
        }
    }
    private func setDefault() {
        if FRData.userData[Date().getConvert()] == nil {
            FRData.userData[Date().getConvert()] = ["weight":[String](), "fitness":[String](), "recipe":[String](), "getCal":[String](), "loseCal":[String](), "Hblood":[String](), "Lblood":[String](), "heartbeat":[String]()]
        }
    }
    private func saveData() {
        self.userDefault.set(FRData.userData, forKey: "FRData")
        self.userDefault.synchronize()
    }
    
    func setBlood(_ Hblood: Int, _ Lblood: Int) {
        setDefault()
        FRData.userData[Date().getConvert()]?["Hblood"]?.removeAll()
        FRData.userData[Date().getConvert()]?["Hblood"]?.append("\(Hblood)")
        FRData.userData[Date().getConvert()]?["Lblood"]?.removeAll()
        FRData.userData[Date().getConvert()]?["Lblood"]?.append("\(Lblood)")
        healthManager.saveBloodPressure(systolic: Double(Hblood), diastolic: Double(Lblood), date: Date()) { (complete, error) in
            if complete {
                print("save in BloodPressure")
            } else {
                if error != nil {
                    print(error)
                }
            }
        }
        saveData()
    }
    func setHeartbeat(_ heartbeat: Int) {
        setDefault()
        FRData.userData[Date().getConvert()]?["heartbeat"]?.removeAll()
        FRData.userData[Date().getConvert()]?["heartbeat"]?.append("\(heartbeat)")
        healthManager.saveHeartRate(heartRate: Double(heartbeat), date: Date()) { (complete, error) in
            if complete {
                print("save in HeartRate")
            } else {
                if error != nil {
                    print(error)
                }
            }
        }
        saveData()
    }
    func setWeight(_ weight: Double) {
        setDefault()
        FRData.userData[Date().getConvert()]!["weight"]!.removeAll()
        FRData.userData[Date().getConvert()]!["weight"]!.append("\(weight)")
        healthManager.saveWeight(weight: weight, date: Date()) { (complete, error) in
            if complete {
                print("save in Weight")
            } else {
                if error != nil {
                    print(error)
                }
            }
        }
        saveData()
    }
    func getData(_ key: String) -> String {
        var r = "-"
        if let userData = FRData.userData[Date().getConvert()] {
            if let data = userData[key] {
                if data.count > 0 {
                    r = data[0]
                }
            }
        }
        return r
    }
    func setGetCal(_ cal: Int) {
        setDefault()
        var nowcal = 0
        if FRData.userData[Date().getConvert()]!["getCal"]!.count > 0 {
            let nc = FRData.userData[Date().getConvert()]!["getCal"]![0] as! String
            nowcal = Int(nc)!
        }
        nowcal += cal
        FRData.userData[Date().getConvert()]!["getCal"]!.removeAll()
        FRData.userData[Date().getConvert()]!["getCal"]!.append("\(nowcal)")
        saveData()
    }
    func reduceGetCal(_ cal: Int) {
        setDefault()
        var nowcal = 0
        if FRData.userData[Date().getConvert()]!["getCal"]!.count > 0 {
            let nc = FRData.userData[Date().getConvert()]!["getCal"]![0] as! String
            nowcal = Int(nc)!
        }
        nowcal -= cal
        FRData.userData[Date().getConvert()]!["getCal"]!.removeAll()
        FRData.userData[Date().getConvert()]!["getCal"]!.append("\(nowcal)")
        saveData()
    }
    func setLoseCal(_ cal: Double) {
        setDefault()
        FRData.userData[Date().getConvert()]!["loseCal"]!.removeAll()
        FRData.userData[Date().getConvert()]!["loseCal"]!.append("\(cal)")
        saveData()
    }
    func setFitness(_ position: Int, value: String) {
        setDefault()
        FRData.userData[Date().getConvert()]!["fitness"]!.append(value)
        let cal = FRData.userData[Date().getConvert()]!["fitness"]!.count * 67
        FRData.userData[Date().getConvert()]!["loseCal"]!.removeAll()
        FRData.userData[Date().getConvert()]!["loseCal"]!.append("\(cal)")
        healthManager.saveActiveEnergyBurned(calory: Double(cal), date: Date()) { (complete, error) in
            if complete {
                print("save in ActiveEnergyBurned")
            } else {
                if error != nil {
                    print(error)
                }
            }
        }
        saveData()
    }
    func setRecipe(_ id: String, _ cal: Int) {
        setDefault()
        if let idx = FRData.userData[Date().getConvert()]!["recipe"]!.firstIndex(of: id) {
            FRData.userData[Date().getConvert()]!["recipe"]!.remove(at: idx)
            reduceGetCal(cal)
        } else {
            FRData.userData[Date().getConvert()]!["recipe"]!.append(id)
            setGetCal(cal)
        }
        saveData()
    }
}
