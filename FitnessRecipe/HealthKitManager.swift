//
//  HealthKitManager.swift
//  FitnessRecipe
//
//  Created by Apple on 6/14/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import HealthKit

struct healthError: Error {
    var desc = ""
    var localizedDescription: String {
        return desc
    }
    init(_ desc: String) {
        self.desc = desc
    }
}

class HealthKitManager {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: @escaping(Bool, Error?) -> Void) {
        let auError = healthError("此版本不支援health")
        
        if !HKHealthStore.isHealthDataAvailable() {
            completion(false, auError)
            return
        }
        let healthDataToWrite = dataTypeToWrite() as! Set<HKSampleType>
        
        healthKitStore.requestAuthorization(toShare: healthDataToWrite, read: nil) { (success, error) in
            completion(success, error)
        }
        
    }
    
    // MARK: - write authority
    func dataTypeToWrite() -> NSSet {
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)
        let bloodHType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)
        let bloodLType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        let caloryType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        
        return NSSet(arrayLiteral: weightType, bloodHType, bloodLType, heartRateType, caloryType)
    }
    
    // MARK: - data save
    func saveWeight(weight: Double, date: Date, completion: @escaping(Bool, Error?) -> Void) {
        
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)
        
        let weightQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo), doubleValue: weight)
        
        let weightSample = HKQuantitySample(type: weightType!, quantity: weightQuantity, start: date, end: date)
        
        healthKitStore.save(weightSample) { (success, error) in
            completion(success, error)
        }
    }
    
    func saveActiveEnergyBurned(calory: Double, date: Date, completion: @escaping(Bool, Error?) -> Void) {
        
        let caloryType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        
        let caloryQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calory)
        
        let calorySample = HKQuantitySample(type: caloryType!, quantity: caloryQuantity, start: date, end: date)
        
        healthKitStore.save(calorySample) { (success, error) in
            completion(success, error)
        }
    }
    
    func saveHeartRate(heartRate: Double, date: Date, completion: @escaping(Bool, Error?) -> Void) {
        
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        
        let heartRateQuantity = HKQuantity(unit: HKUnit.count().unitDivided(by: .minute()), doubleValue: heartRate)
        
        let heartRateSample = HKQuantitySample(type: heartRateType!, quantity: heartRateQuantity, start: date, end: date)
        
        healthKitStore.save(heartRateSample) { (success, error) in
            completion(success, error)
        }
    }
    
    func saveBloodPressure(systolic: Double, diastolic: Double, date: Date, completion: @escaping(Bool, Error?) -> Void) {
        
        let bloodHType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)
        let bloodLType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)
        
        let bloodHQuantity = HKQuantity(unit: HKUnit.millimeterOfMercury(), doubleValue: systolic)
        let bloodLQuantity = HKQuantity(unit: HKUnit.millimeterOfMercury(), doubleValue: diastolic)
        
        let bloodHSample = HKQuantitySample(type: bloodHType!, quantity: bloodHQuantity, start: date, end: date)
        let bloodLSample = HKQuantitySample(type: bloodLType!, quantity: bloodLQuantity, start: date, end: date)
        
        
        let bpCorrelationType = HKCorrelationType.correlationType(forIdentifier: .bloodPressure)!
        let bpCorrelation = Set<HKSample>(arrayLiteral: bloodHSample, bloodLSample)
        let bloodPressureSample = HKCorrelation(type: bpCorrelationType , start: date, end: date, objects: bpCorrelation)
        
        healthKitStore.save(bloodPressureSample) { (success, error) in
            completion(success, error)
        }
    }

}
