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
        self.title = "Select a City"
        citiNameTblView.delegate = self
        citiNameTblView.dataSource = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: .done, target: self, action: #selector(self.action(sender:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataRepository.shared.delegate = self
        DataRepository.shared.fetchDataFromDb()
        self.citiNameTblView.reloadData()
    }
    
    @objc func action(sender: UIBarButtonItem) {
       performSegue(withIdentifier: "addDetail", sender: nil)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "weatherDetails" {
            if let detailViewController = segue.destination as? WeatherDetailViewController, let city = selectedCity {
                detailViewController.selectedCity = city
            }
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

extension CitiNameViewController: DataRepositoryDelegate {
    func dataWriteToDataStore() {
    }
    
    func fetchDataFromDS(_ weatherData: [WeatherData]) {
        citiesList = weatherData
        if Reachability.isConnectedToNetwork() {
            if !citiesList.isEmpty {
                var weatherDataList : [WeatherData] = []
                let dispatchGroup = DispatchGroup()
                citiesList.forEach { (city) in
                    DataRepository.shared.deleteCityFromDb(city)
                    dispatchGroup.enter()
                    if let citiName = city.name {
                        weatherService.fetchWeatherDataFromServer(city: citiName) { (response, error) in
                            guard let response = response else {
                                return
                            }
                            DispatchQueue.main.async {
                                dispatchGroup.leave()
                                weatherDataList.append(response)
                                DataRepository.shared.addDataToDataStore(response)
                            }
                        }

                        dispatchGroup.notify(queue: .main) {
                            self.citiesList = weatherDataList
                            self.citiNameTblView.reloadData()
                        }
                    }
                }
            }

        }
        
      
    }
}
