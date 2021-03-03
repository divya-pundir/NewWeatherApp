//
//  WeatherForecastCell.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/3/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import UIKit

class WeatherForecastCell: UITableViewCell {

    
    @IBOutlet weak var cellMinTempLabel: UILabel!
    @IBOutlet weak var cellMaxTempLabel: UILabel!
    @IBOutlet weak var cellDateLabel: UILabel!
    @IBOutlet weak var cellCondTempLabel: UILabel!
    @IBOutlet weak var cellCondIconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
