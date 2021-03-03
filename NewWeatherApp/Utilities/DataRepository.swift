//
//  DataRepository.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/3/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import UIKit
import CoreData

protocol DataRepositoryDelegate: NSObject {
    func dataWriteToDataStore()
    func fetchDataFromDS(_ weatherData: [WeatherData])
}

class DataRepository {
    
    static let shared = DataRepository()
    weak var delegate: DataRepositoryDelegate?
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let CityModel = "CityModl"
    
    private init() {}
    
    func addDataToDataStore(_ weatherDetail : WeatherData) {
        
               let entity = NSEntityDescription.entity(forEntityName: CityModel, in: managedObjectContext)!
               let data = NSManagedObject(entity: entity, insertInto: managedObjectContext)
              
               if let obj = try? JSONEncoder().encode(weatherDetail)  {
                    data.setValue(obj, forKey: "weatherData")
                    try? managedObjectContext.save()
                delegate?.dataWriteToDataStore()
            }
        }
    
    func fetchDataFromDb() {
        var weatherDataList : [WeatherData] = []
        do {
            let request = NSFetchRequest<NSManagedObject>(entityName: CityModel)
            
            let cities = try managedObjectContext.fetch(request)
            if !cities.isEmpty {
                cities.forEach { (city) in
                    if let citi = try? JSONDecoder().decode(WeatherData.self, from: city.value(forKey: "weatherData") as! Data) {
                        weatherDataList.append(citi)
                    }
                }
            }
            delegate?.fetchDataFromDS(weatherDataList)
        }
        catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func deleteCityFromDb(_ cityName: WeatherData) {
        do {
            let request = NSFetchRequest<NSManagedObject>(entityName: CityModel)
            let cities = try managedObjectContext.fetch(request)
            if !cities.isEmpty {
                cities.forEach { (city) in
                    if let citi = try? JSONDecoder().decode(WeatherData.self, from: city.value(forKey: "weatherData") as! Data) {
                        if cityName.name == citi.name {
                            managedObjectContext.delete(city)
                        }
                    }
                }
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
   
    }
}
