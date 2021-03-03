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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
    @IBAction func addCity(_ sender: Any) {
        if let citiName = cityTextField.text {
            weatherService.fetchWeatherDataFromServer(city: citiName) { (response, error) in
                guard let response = response else {
                   return
                }
                
                DispatchQueue.main.async {
                    DataRepository.shared.delegate = self
                    DataRepository.shared.addDataToDataStore(response)
                    
                }
            }
        }
   }
}

extension AddCityViewController: DataRepositoryDelegate {
    func fetchDataFromDS(_ weatherData: [WeatherData]) {
        
    }
    
    func dataWriteToDataStore() {
         navigationController?.popViewController(animated: true)
    }
    
}
