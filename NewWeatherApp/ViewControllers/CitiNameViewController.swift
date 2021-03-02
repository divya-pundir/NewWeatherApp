//
//  CitiNameViewController.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/2/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import UIKit
import CoreData

class CitiNameViewController : UIViewController {
    
    var citiesList: [WeatherData] = []
    var selectedCity : String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        do {
            var weatherDataList : [WeatherData] = []
            
            let request = NSFetchRequest<NSManagedObject>(entityName: "ModelCiti")
            
                let cities = try context.fetch(request)
            if !cities.isEmpty {
                cities.forEach { (city) in
                    if let citi = try? JSONDecoder().decode(WeatherData.self, from: city.value(forKey: "weatherData") as! Data) {
                        weatherDataList.append(citi)
                    }
                }
                citiesList = weatherDataList
            }
            debugPrint(citiesList)
        }
        catch {
            debugPrint(error.localizedDescription)
        }
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? WeatherDetailViewController, let city = selectedCity {
            detailViewController.selectedCity = city
        }
    }
}

extension CitiNameViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "citiNameCell", for: indexPath) as? CitiTableViewCell else {
            fatalError()
        }
        cell.citiLabel.text = citiesList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedCity = cities[indexPath.row]
        performSegue(withIdentifier: "weatherDetails", sender: nil)
    }
}
