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
    var selectedCity : WeatherData?
   
    @IBOutlet weak var citiNameTblView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    lazy var weatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiNameTblView.delegate = self
        citiNameTblView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWeatherData()
        self.citiNameTblView.reloadData()
    }
    
    func getWeatherData() {
        if !Reachability.isConnectedToNetwork() {
            self.fetchDataFromDb()
            return
        }
        fetchDataFromServer()
    }
    
    func fetchDataFromDb() {
        do {
            var weatherDataList : [WeatherData] = []
            
            let request = NSFetchRequest<NSManagedObject>(entityName: "CityNameModel")
            
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
    
    func fetchDataFromServer() {
        do {
            var weatherDataList : [WeatherData] = []
            let request = NSFetchRequest<NSManagedObject>(entityName: "CityNameModel")
            let cities = try context.fetch(request)
            if !cities.isEmpty {
              let dispatchGroup = DispatchGroup()
                cities.forEach { (city) in
                    context.delete(city)
                    dispatchGroup.enter()
                    if let citi = try? JSONDecoder().decode(WeatherData.self, from: city.value(forKey: "weatherData") as! Data), let cityName = citi.name {
                        weatherService.fetchWeatherDataFromServer(city: cityName) { [weak self](response, error) in
                            guard let response = response else {
                                return
                            }
                            DispatchQueue.main.async {
                                dispatchGroup.leave()
                                weatherDataList.append(response)
                                if let managedContext = self?.context {
                                    let entity = NSEntityDescription.entity(forEntityName: "CityNameModel", in: managedContext)!
                                    let data = NSManagedObject(entity: entity, insertInto: managedContext)
                                    if let obj = try? JSONEncoder().encode(response)  {
                                    data.setValue(obj, forKey: "weatherData")
                                    try? managedContext.save()
                                }
                                }
                                self?.citiesList = weatherDataList
                            }
                        }
                        dispatchGroup.notify(queue: .main) {
                            DispatchQueue.main.async {
                                self.citiNameTblView.reloadData()
                            }
                            
                        }
                    }
                    
                }
            }
        } catch {
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
        selectedCity = citiesList[indexPath.row]
        performSegue(withIdentifier: "weatherDetails", sender: nil)
    }
}
