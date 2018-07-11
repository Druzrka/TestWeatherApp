//
//  NavigationItemWithoutBackTitle.swift
//  WeatherApp
//
//  Created by Захар on 05.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import UIKit

class NavigationItemWithoutBackTitle: UINavigationItem {

    override func awakeFromNib() {
        super.awakeFromNib()
    
        backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
