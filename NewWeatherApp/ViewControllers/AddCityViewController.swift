//
//  AddCityViewController.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/2/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import UIKit
import CoreData

class AddCityViewController: UIViewController {
    @IBOutlet weak var cityTextField : UITextField!
    lazy var weatherService = WeatherService()
   
    @IBAction func addCity(_ sender: Any) {
        if let citiName = cityTextField.text {
            weatherService.fetchWeatherDataFromServer(city: citiName) { [weak self](response, error) in
                print(response)
                guard let response = response else {
                   return
                }
                DispatchQueue.main.async {
                     self?.addDataToDataStore(response)
                }
            }
        }
   }
    
    func addDataToDataStore(_ weatherDetail : WeatherData) {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
               let entity = NSEntityDescription.entity(forEntityName: "ModelCiti", in: managedObjectContext)!
               let data = NSManagedObject(entity: entity, insertInto: managedObjectContext)
              
               if let obj = try? JSONEncoder().encode(weatherDetail)  {
                   data.setValue(obj, forKey: "weatherData")
                    try? managedObjectContext.save()
     }
              
        dismiss(animated: true, completion: nil)
    }
    
}
