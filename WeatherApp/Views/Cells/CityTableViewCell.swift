//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Захар on 04.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCell()
    }
    
    private func configureCell() {
        
        backgroundColor = .black
        textLabel?.textColor = .white
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        textLabel?.font = R.font.sfProTextRegular(size: 17)
    }
}
