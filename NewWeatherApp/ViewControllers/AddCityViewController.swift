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
         self.title = "Add a City"
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
    @IBAction func addCity(_ sender: Any) {
        if let citiName = cityTextField.text {
            weatherService.fetchWeatherDataFromServer(city: citiName) { [weak self](response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.displayAlert(error)
                    }
                }
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
    
    func displayAlert(_ error: Error) {
        let alert = UIAlertController(title: "Add a city", message: "Please add a valid city", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        }))

       
        present(alert, animated: true, completion: nil)
    }
}

extension AddCityViewController: DataRepositoryDelegate {
    func fetchDataFromDS(_ weatherData: [WeatherData]) {
        
    }
    
    func dataWriteToDataStore() {
         navigationController?.popViewController(animated: true)
    }
    
}
