//
//  APIService.swift
//  CurrencyConvertor
//
//  Created by Hamid Farooq on 14/01/2021.
//

import Foundation
import ProgressHUD
import Reachability

fileprivate let baseURL: String = "http://api.currencylayer.com"
fileprivate let livePath: String = "/live"

fileprivate let accessKey: String = "6537ade708cab4cf4ab5581818d4c228"

// This is just a temporary error message for no internet
fileprivate let internetConnectionErrorJson = "{\"success\":false,\"error\":{\"code\":1009,\"info\":\"No internet connection\"}}"

class APIService {
    
    // MARK: - Properties
    
    fileprivate var internetConnectionError: ErrorModel? = {
        if let data = internetConnectionErrorJson.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(ErrorModel.self, from: data)
            }
            catch let exception {
                debugPrint("Failed to serialize json:", exception)
            }
        }
        return nil
    }()
    
    var internetConnectionAvailable: Bool = false
    
    let reachability = try! Reachability()
    
    // MARK: - Initialization
    
    init() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                debugPrint("Reachable via WiFi")
                self.internetConnectionAvailable = true
            }
            else {
                debugPrint("Reachable via Cellular")
                self.internetConnectionAvailable = true
            }
        }
        reachability.whenUnreachable = { _ in
            debugPrint("Not reachable")
            self.internetConnectionAvailable = false
        }
        
        do {
            try reachability.startNotifier()
            
            internetConnectionAvailable = reachability.connection == .wifi || reachability.connection == .cellular
        } catch {
            debugPrint("Unable to start notifier")
        }
    }
    
    // MARK: - API Service Methods
    
    func fetchCurrencies<T: Decodable>(for currency: Currency?, _ completion: @escaping (T?, Error?) -> ()) {
        guard internetConnectionAvailable else {
            completion(nil, internetConnectionError)
            return
        }
        ProgressHUD.show("Updating...")
        
        var urlString = "\(baseURL)\(livePath)?access_key=\(accessKey)"
        if let currency = currency {
            urlString += "&source=\(currency.symbol)"
        }
        
        fetchData(urlString: urlString) { (object: T?, error) in
            if let _ = object {
                ProgressHUD.showSucceed("Updated")
            }
            else {
                ProgressHUD.showFailed()
            }
            
            completion(object, error)
        }
    }
}

extension APIService {
    
    func fetchData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        debugPrint("URL: ", url)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                else if let responseData: T = self.handleResponse(data: data) {
                    completion(responseData, nil)
                }
                else if let responseErrorData: ErrorModel = self.handleResponse(data: data) {
                    completion(nil, responseErrorData)
                }
            }
        }.resume()
        
    }
    
    func handleResponse<T: Decodable>(data: Data?) -> T? {
        guard let data = data else { return nil }
        
        do {
            let responseModel = try JSONDecoder().decode(T.self, from: data)
            debugPrint("Response: ", responseModel)
            
            return responseModel
        }
        catch let exception {
            debugPrint("Failed to serialize json:", exception)
        }
        return nil
    }
}
