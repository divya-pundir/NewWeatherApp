//
//  CitiNameViewController.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/2/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import UIKit

class CitiNameViewController : ViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cities : [String] = ["Delhi", "Goa"]
    
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
        //get citi details
        
    }
}
