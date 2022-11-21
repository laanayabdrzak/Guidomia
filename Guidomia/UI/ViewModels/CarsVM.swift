//
//  CarsVM.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import Foundation

class CarsVM {
    
    public var carsItems: [Car]?
    
    init() {
        carsItems = readLocalJSONFile(filename: Constants.carList)
    }
    
    func readLocalJSONFile(filename fileName: String) -> [Car]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Car].self, from: data)
                return jsonData
            } catch {
                print("Error:\(error)")
            }
        }
        return nil
    }
}
