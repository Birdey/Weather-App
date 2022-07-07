//
//  WeatherCell.swift
//  Weather App
//
//  Created by Christoffer Nilsson on 2022-07-07.
//

import UIKit

class WeatherCell: UITableViewCell{
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var townNameLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
