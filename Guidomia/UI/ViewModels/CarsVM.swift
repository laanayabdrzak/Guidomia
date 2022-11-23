//
//  CarsVM.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import Foundation
import CoreData

class CarsVM {
    
    public var carsItems: [CarCodeable]?
    
    init() {
        self.carsItems = readLocalJSONFile(filename: Constants.carList)
    }
    
    func readLocalJSONFile(filename fileName: String) -> [CarCodeable]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONDecoder().decode([CarCodeable].self, from: data)
                return jsonData
            } catch {
                print("Error:\(error)")
            }
        }
        return nil
    }
    
    private func createCarEntityFrom(_ car: CarCodeable) -> NSManagedObject? {
        let context = DatabaseHelper.sharedInstance.persistentContainer.viewContext
        if let carEntity = NSEntityDescription.insertNewObject(forEntityName: "Car", into: context) as? Car {
            // Set the data to the entity
            carEntity.setValue(car.make, forKey: "make")
            carEntity.setValue(car.model, forKey: "model")
            carEntity.setValue(car.marketPrice, forKey: "marketPrice")
            carEntity.setValue(car.customerPrice, forKey: "customerPrice")
            carEntity.setValue(car.rating, forKey: "rating")
            
            return carEntity
        }
        return nil
    }
    
    func saveInCoreDataWith(array:[CarCodeable]) {
        _ = array.map({self.createCarEntityFrom($0)})
        do {
            try DatabaseHelper.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}

