//
//  CurrencyView.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import UIKit

class CurrencyView: UIView {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Properties
    
    var currency: Currency!
    
    // MARK: - Initialization
    
    /// Returns an object initialized from data in a given unarchiver
    /// @params aDecoder An unarchiver object
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    /// Initializes and returns a newly allocated view object with the specified frame rectangle
    /// @params frame The frame rectangle for the view, measured in points
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 4
        imageView.image = nil
        titleLabel.text = ""
    }
}

// MARK: Public

extension CurrencyView {

    func setTitleColor(_ color: UIColor = .white) {
        titleLabel.textColor = color
    }
    
    func setCurrency(_ object: Currency) {
        self.currency = object
        
        if let image = UIImage(named: object.symbol.lowercased()) {
            imageView.image = image
        }
        titleLabel.text = object.symbol
    }
}
