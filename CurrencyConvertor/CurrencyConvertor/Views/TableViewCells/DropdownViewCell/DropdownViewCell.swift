//
//  DropdownViewCell.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import UIKit
import DropDown

class DropdownViewCell: DropDownCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: Properties
    
    class var identifier: String { return String(describing: self) }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        optionLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            if newValue != UIColor.clear {
                super.backgroundColor = newValue
            }
        }
    }
}

// MARK: Public

extension DropdownViewCell {
    
    func setCurrency(_ object: Currency) {
        if let image = UIImage(named: object.symbol.lowercased()) {
            iconImageView.image = image
        }
    }
}
