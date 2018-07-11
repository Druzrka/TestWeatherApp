//
//  CityWeatherCell.swift
//  WeatherApp
//
//  Created by Захар on 05.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import UIKit

class CityWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFonts()
    }
    
    private func setupFonts() {
        cityNameLabel.font = R.font.sfProTextRegular(size: 15)
        weatherLabel.font = R.font.sfProDisplayLight(size: 15)
    }
}
