//
//  UIView.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import UIKit

extension UIView {
    
    /// Load nib from file and add as subview
    func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first! as! UIView
        view.frame = bounds
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
