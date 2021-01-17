//
//  ViewController.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import UIKit
import Toast

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: CurrencyInputView!
    
    // MARK: Properties
    
    private let refreshControl = UIRefreshControl()
    private var service = APIService()
    
    private var timer: Timer?
    
    var currencies = [Currency]()
    var selectedCurrency: Currency!
    {
        didSet {
            inputValue = defaultInputValue
        }
    }
    
    private var autoRefreshEnabled = true
    private var inputValue: Float = defaultInputValue
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timer = Timer.scheduledTimer(withTimeInterval: defaultRefreshRate, repeats: true, block: { _ in
            self.fetchCurrencyData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        prepareTableView()
        prepareHeaderView()
        
        fetchBaseCurrency()
        fetchCurrencyData()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}

extension ViewController {
    
    func prepareTableView() {
        let cellIdentifier = CurrencyViewCell.identifier
        let tableViewCell = UINib(nibName: cellIdentifier, bundle: nil)
        
        tableView.register(tableViewCell, forCellReuseIdentifier: cellIdentifier)
        
        tableView.refreshControl = refreshControl
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshCurrencyData(_:)), for: .valueChanged)

    }
    
    func prepareHeaderView() {
        headerView.didChangeCurreny = { currency in
            self.selectedCurrency = currency
            self.fetchCurrencyData()
        }
        headerView.didChangeCurrencyValue = { value in
            self.inputValue = value
            self.prepareCurrencyRates()
        }
        headerView.didChangeDataSourceRefreshEnabled = { enabled in
            self.autoRefreshEnabled = enabled
        }
    }
    
    func prepareBaseCurrency(for object: ResponseModel? = nil) {
        if AppDelegate.instance.baseCurrency == nil {
            if let object = object {
                Currency.insertOrUpdate(object.source, defaultInputValue, defaultInputValue, base: true)
            }
        }
        
        fetchBaseCurrency()
    }
    
    func fetchBaseCurrency() {
        if selectedCurrency == nil {
            if let currency = Currency.fetchBaseCurrency() {
                AppDelegate.instance.baseCurrency = currency
            }
            
            selectedCurrency = AppDelegate.instance.baseCurrency
        }
        
        guard let currency = selectedCurrency else { return }
        headerView.setCurrency(currency)
    }
}

extension ViewController {
    
    @objc
    private func refreshCurrencyData(_ sender: Any) {
        fetchCurrencyData()
    }
    
    private func refreshTableView() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyViewCell.identifier) as? CurrencyViewCell else { return UITableViewCell() }
        
        cell.setCurrency(currencies[indexPath.row])
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.white : UIColor.lightGray.withAlphaComponent(0.1)
        
        return cell
    }
}

// MARK: Data Handler Methods

extension ViewController {
    
    func fetchCurrencyData() {
        if autoRefreshEnabled == false {
            guard Currency.fetchCount() <= 1 else {
                prepareDataSet()
                return
            }
        }
        
        service.fetchCurrencies(for: selectedCurrency, fetchCurrencyDataHandler)
    }
    
    func fetchCurrencyDataHandler(_ object: ResponseModel?, _ error: Error?) {
        if let error = error as? ErrorModel {
            debugPrint(error)
            
            view.makeToast(error.error.info)
        }
        
        prepareDataSet(for: object)
    }
    
    func prepareDataSet(for object: ResponseModel? = nil) {
        prepareCurrencyRates(for: object)
        
        prepareBaseCurrency(for: object)
    }
    
    func prepareCurrencyRates(for object: ResponseModel? = nil) {
        if let object = object {
            insertOrUpdateCurrencyRates(with: object)
        }
        else {
            calculateCurrencyRates()
        }
        
        currencies.removeAll()
    
        currencies.append(contentsOf: Currency.fetch())
        
        headerView.setDropdownDataSource(currencies)
        
        refreshTableView()
    }
    
    func insertOrUpdateCurrencyRates(with object: ResponseModel) {
        let quotes = object.quotes
        let keys = quotes.keys.sorted(by: { $0 < $1 })
        keys.forEach { key in
            let value = quotes[key] ?? defaultInputValue
            
            Currency.insertOrUpdate(key, value, value)
        }
    }
    
    func calculateCurrencyRates() {
        guard selectedCurrency != nil else  { return }
        
        let currencies = Currency.fetch()
        currencies.forEach { currency in
            currency.setValue(convert(selectedCurrency, to: currency), forKey: "calcValue")
        }
        
        do {
            try Currency.managedObjectContext.save()
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - Currency Convertor

extension ViewController {
    
    func convert(_ selected: Currency, to currency: Currency) -> Float {
        if let base = AppDelegate.instance.baseCurrency {
            if base.symbol == selected.symbol {
                return currency.value * inputValue
            }
            else {
                return (currency.value / selected.value) * inputValue
            }
        }
        return defaultInputValue
    }
}
