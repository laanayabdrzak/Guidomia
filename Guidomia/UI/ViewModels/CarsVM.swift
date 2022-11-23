//
//  CarsVM.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import Foundation
import CoreData

class CarsVM {
    
    let userDefault = UserDefaults.standard
    public var carsItems: [CarCodeable]?
    
    init() {
        /** In case you wanna remove data `self.clearData()`
         */
        if userDefault.bool(forKey: Constants.firstLaunchKey) == true {
            // Run Code during after first launch
            userDefault.set(true, forKey: Constants.firstLaunchKey)
            self.carsItems = fetchFromCoreData()
        } else {
            // Run Code during first launch
            userDefault.set(true, forKey: Constants.firstLaunchKey)
            self.carsItems = readLocalJSON(filename: Constants.carsJSonFile)
            self.saveInCoreDataWith(array: carsItems ?? [])
        }
    }
    
    private func readLocalJSON(filename fileName: String) -> [CarCodeable]? {
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
        if let carEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: Car.self), into: context) as? Car {
            // Set the data to the entity
            carEntity.setValue(car.make, forKey: Constants.makeAttKeyEntity)
            carEntity.setValue(car.model, forKey: Constants.modelAttKeyEntity)
            carEntity.setValue(car.marketPrice, forKey: Constants.marketPriceAttKeyEntity)
            carEntity.setValue(car.customerPrice, forKey: Constants.customerPriceAttKeyEntity)
            carEntity.setValue(car.rating, forKey: Constants.ratingAttKeyEntity)
            carEntity.setValue(car.prosList.joined(separator: ","), forKey: Constants.prosListAttKeyEntity)
            carEntity.setValue(car.consList.joined(separator: ","), forKey: Constants.consListAttKeyEntity)
            return carEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(array:[CarCodeable]) {
        _ = array.map({self.createCarEntityFrom($0)})
        do {
            try DatabaseHelper.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func fetchFromCoreData() -> [CarCodeable]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Car.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
        let context = DatabaseHelper.sharedInstance.persistentContainer.viewContext
        do {
            let carsModel = try context.fetch(fetchRequest) as? [Car] ?? []
            var carObjects = [CarCodeable]()
            for car in carsModel {
                let tmpCar = CarCodeable(make: car.make!,
                                         model: car.model!,
                                         customerPrice: car.customerPrice,
                                         marketPrice: car.marketPrice,
                                         rating: Int(car.rating),
                                         consList: car.consList?.components(separatedBy: ",") ?? [],
                                         prosList: car.prosList?.components(separatedBy: ",") ?? [])
                carObjects.append(tmpCar)
            }
            return carObjects
            
        } catch {
            let fetchError = error as NSError
            print("ERROR FETCHING : \(fetchError)")
        }
        return nil
    }
    
    private func clearData() {
        do {
            
            let context = DatabaseHelper.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Car.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                DatabaseHelper.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}

