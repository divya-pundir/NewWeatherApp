//
//  CitiNameViewController.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/2/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import UIKit

class CitiNameViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cities : [String] = ["Delhi", "Goa"]
    var selectedCity : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.weatherDataForLocation(cityName: "Delhi") { (response, error) in
            print(response)
        }
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "citiNameCell", for: indexPath) as? CitiTableViewCell else {
            fatalError()
        }
        cell.citiLabel.text = cities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCity = cities[indexPath.row]
        performSegue(withIdentifier: "weatherDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? WeatherDetailViewController, let city = selectedCity {
            detailViewController.selectedCity = city
        }
    }
}
