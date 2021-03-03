//
//  WeatherDetailViewController.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/2/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import UIKit

class WeatherDetailViewController : UIViewController {
    
    var selectedCity : WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("WeatherDetailViewController - \(String(describing: selectedCity))")
    }
}

extension WeatherDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as? DetailTableViewCell else {
            fatalError()
        }
        cell.titleLabel.text = selectedCity?.name
        cell.valueLabel.text = String(format: "%f", selectedCity?.main?.temp ?? "")
        return cell
    }
}
