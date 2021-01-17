//
//  Currency.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import Foundation
import CoreData

class Currency: NSManagedObject {
    
    @NSManaged dynamic var symbol: String
    @NSManaged dynamic var quote: String
    @NSManaged dynamic var value: Float
    @NSManaged dynamic var calcValue: Float
    @NSManaged dynamic var base: Bool
}

extension Currency {
    
    class var stringValue: String { return String(describing: Currency.self) }
    
    class var managedObjectContext: NSManagedObjectContext { return AppDelegate.instance.managedObjectContext }
    
    class func fetchBaseCurrency() -> Currency? {
        let predicate = NSPredicate(format: "base = true")
        return fetchCurrency(with: predicate)
    }
    
    class func fetchCurrency(_ quote: String) -> Currency? {
        let predicate = NSPredicate(format: "(quote = %@) OR (symbol = %@)", quote, quote)
        return fetchCurrency(with: predicate)
    }
    
    class func fetchCurrency(with predicate: NSPredicate? = nil) -> Currency? {
        let currencies = fetch(predicate)
        
        return currencies.first
    }
    
    class func fetch(_ predicate: NSPredicate? = nil) -> [Currency] {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: Currency.stringValue)

        let sortDescriptor = NSSortDescriptor(key: "symbol", ascending: true)
        
        fetch.sortDescriptors = [sortDescriptor]
        fetch.predicate = predicate
        
        var result = [AnyObject]()
        do {
            result = try managedObjectContext.fetch(fetch)
        } catch let error as NSError {
            debugPrint("Error fetching currencies error: %@", error)
        }
        
        return result as! [Currency]
    }
    
    class func fetchCount(_ predicate: NSPredicate? = nil) -> Int {
        var count: Int = 0
        
        managedObjectContext.performAndWait {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: Currency.stringValue)
            
            fetch.predicate = predicate
            fetch.resultType = .countResultType
            
            do {
                count = try managedObjectContext.count(for: fetch)
            } catch {
                debugPrint("Error fetching count error: %@", error)
            }
        }
        
        return count
    }
    
    class func insertOrUpdate(_ quote: String, _ value: Float = defaultInputValue, _ calcValue: Float = defaultInputValue, base: Bool = false) {
        if update(quote, value, calcValue, base: base) == false {
            insert(quote, value, calcValue, base: base)
        }
    }
    
    class private func insert(_ quote: String, _ value: Float = defaultInputValue, _ calcValue: Float = defaultInputValue, base: Bool = false) {
        let entity = NSEntityDescription.entity(forEntityName: Currency.stringValue, in: managedObjectContext)!
        
        let currency = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        currency.setValue(quote, forKey: "quote")
        currency.setValue(quote.currencyCode, forKey: "symbol")
        currency.setValue(value, forKey: "value")
        currency.setValue(calcValue, forKey: "calcValue")
        currency.setValue(base, forKey: "base")
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class private func update(_ quote: String, _ value: Float = defaultInputValue, _ calcValue: Float = defaultInputValue, base: Bool = false) -> Bool {
        if let currency = fetchCurrency(quote) {
            
            currency.setValue(value, forKey: "value")
            currency.setValue(calcValue, forKey: "calcValue")
            currency.setValue(base, forKey: "base")
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                debugPrint("Could not save. \(error), \(error.userInfo)")
            }
            
            return true
        }
        return false
    }
}
