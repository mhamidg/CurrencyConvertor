//
//  CurrencyViewCell.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import UIKit

class CurrencyViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var currencyView: CurrencyView!
    @IBOutlet weak var valueLabel: UILabel!
        
    // MARK: Properties
    
    class var identifier: String { return String(describing: self) }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        valueLabel.text = ""
    }
}

// MARK: Public

extension CurrencyViewCell {
    
    func setCurrency(_ object: Currency) {
        currencyView.setCurrency(object)
        valueLabel.text = String(format: "%.4f", object.calcValue)
    }
}
