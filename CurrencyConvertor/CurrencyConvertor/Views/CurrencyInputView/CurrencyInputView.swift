//
//  CurrencyInputView.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import UIKit
import DropDown

class CurrencyInputView: UIView {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var currencyView: CurrencyView!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var updateSwich: UISwitch!
    
    // MARK: Properties
    
    let dropdown = DropDown()
    
    private var dropdownDataSource = [Currency]()
    
    // MARK: Events
    
    public var didChangeCurreny: ((Currency) -> Void)?
    public var didChangeCurrencyValue: ((Float) -> Void)?
    public var didChangeDataSourceRefreshEnabled: ((Bool) -> Void)?
    
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
        
        prepareView()
        prepareDropdown()
    }
    
    // MARK: Action
    
    @IBAction func updateSwichChangeValue(_ sender: UISwitch) {
        didChangeDataSourceRefreshEnabled?(sender.isOn)
    }
    
    @IBAction func dropdownButtonAction(_ sender: UIButton) {
        textField.resignFirstResponder()
        
        dropdown.show()
    }
}

// MARK: Private

extension CurrencyInputView {
    
    func prepareView() {
        currencyView.setTitleColor()
        
        dropdownButton.layer.cornerRadius = 6
        dropdownButton.layer.borderWidth = 2
        dropdownButton.layer.borderColor = UIColor.systemGreen.cgColor
            
        dropdown.accessibilityIdentifier = "dropdown"
    }
    
    func prepareDropdown() {
        DropDown.setupDefaultAppearance()
        
        dropdown.anchorView = dropdownButton
        
        dropdown.dismissMode = .automatic
        dropdown.direction = .any
        
        dropdown.bottomOffset = CGPoint(x: 0, y: dropdownButton.bounds.height)
        dropdown.width = dropdownButton.frame.width
        
        dropdown.cellNib = UINib(nibName: "DropdownViewCell", bundle: nil)
        
        dropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? DropdownViewCell else { return }
            
            // Setup your custom UI components
            cell.setCurrency(self.dropdownDataSource[index])
            cell.backgroundColor = (index % 2 == 0) ? UIColor.white : UIColor.lightGray.withAlphaComponent(0.1)
        }
        
        // Action triggered on selection
        dropdown.selectionAction = { (index, item) in
            debugPrint("Select currency \(item)")
            
            let currency = self.dropdownDataSource[index]
            self.setCurrency(currency)
            self.didChangeCurreny?(currency)
            
            //self.dropdown.deselectRow(index)
        }
    }
}

// MARK: Public

extension CurrencyInputView {
    
    func prepareForInput() {
        textField.becomeFirstResponder()
    }
    
    func setCurrency(_ object: Currency) {
        textField.text = defaultInputStringValue
        currencyView.setCurrency(object)
    }
    
    func setDropdownDataSource(_ dataSource: [Currency]) {
        dropdownDataSource = dataSource
        dropdown.dataSource = dataSource.map({ $0.symbol })
    }
}

// MARK: UITextFieldDelegate

extension CurrencyInputView : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? String()
        guard let stringRange = Range(range, in: text) else { return false }
        
        let allowedCharacter = CharacterSet(charactersIn: ".")
        let allowedCharacters = CharacterSet.decimalDigits.union(allowedCharacter)
        let characterSet = CharacterSet(charactersIn: string)
        let result = allowedCharacters.isSuperset(of: characterSet)
        
        if result {
            let updatedText = text.replacingCharacters(in: stringRange, with: string)
            let value = Float(updatedText) ?? defaultInputValue
            didChangeCurrencyValue?(value)
        }
        
        return result
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
