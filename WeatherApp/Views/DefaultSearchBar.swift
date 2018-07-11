//
//  DefaultSearchBar.swift
//  WeatherApp
//
//  Created by Захар on 04.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import UIKit

protocol DefaultSearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
}

class DefaultSearchBar: UISearchBar {
    
    private var inputTextField = UITextField()
    
    public var defaultSearchBarDelegate: DefaultSearchBarDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        inputTextField = self.value(forKey: "searchField") as! UITextField
        returnKeyType = .done
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setSearchIconToCenter()
        setSearchBarColors()
        inputTextField.font = R.font.sfProTextRegular(size: 17)
    }
    
    private func setSearchIconToCenter() {
        
        let placeHolderWidth: CGFloat = 60.0
        setPositionAdjustment(UIOffset(horizontal: U.screen.width / 2 - 60, vertical: 0), for: UISearchBarIcon.search)
    }
    
    private func setDefaultPlaceHolderPositionAndTitle() {
        self.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: UISearchBarIcon.search)
        self.placeholder = ""
    }

    // Colors configuration methods
    private func setSearchBarColors() {
        
        let grayColor = UIColor(red:0.12, green:0.14, blue:0.15, alpha:1.0)
        
        inputTextField.backgroundColor = grayColor
        backgroundColor = UIColor.black
        tintColor = UIColor.black
        inputTextField.textColor = UIColor.white
        keyboardAppearance = .dark
    }
}

// MARK: Search bar delegate
extension DefaultSearchBar: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setDefaultPlaceHolderPositionAndTitle()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        defaultSearchBarDelegate?.searchBar(searchBar, textDidChange: searchText)
        if searchText.isEmpty {
            resignFirstResponder()
            placeholder = "Search"
            setSearchIconToCenter()
            
        } else {
            setDefaultPlaceHolderPositionAndTitle()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        placeholder = "Search"
        setSearchIconToCenter()
    }
}
