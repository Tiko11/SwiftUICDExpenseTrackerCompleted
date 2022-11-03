//
//  Request.swift
//  ExpenseTracker
//
//  Created by Tinatini Charkviani on 30.10.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

protocol Request {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
}

enum RequestError: Swift.Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
}

extension RequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .invalidURL: return "Invalid URL"
            case let .httpCode(code): return "Unexpected HTTP code: \(code)"
            case .unexpectedResponse: return "Unexpected response from the server"
        }
    }
}

extension Request {
    func urlRequest(params: [String: Any], baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw RequestError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

protocol Repository {
    var session: URLSession { get }
    var baseURL: String { get }
    var bgQueue: DispatchQueue { get }
}

enum Currencies: String {
    case euro = "EUR", dollar = "USD"
}

struct CurrencyParameters {
    var amount: Double
    var toCurrency, fromCurrency: String
}

struct Currency {
    typealias JSON = [String: Any]

    var amount, rate: Double
    
    enum CodingKeys: String {
        case amount
        case rate
    }
    
    init() {
        amount = 90
        rate = 19
        
    }
    
    init(json: JSON) {
        self.amount = json[CodingKeys.amount.rawValue] as? Double ?? 0
        self.rate = json[CodingKeys.amount.rawValue] as? Double ?? 0
    }
}

protocol CurrencyRepositoryInterface: Repository {
    func convertCurrency(amount: Double,
                         isEnabled: Bool,
                         completion: @escaping (Currency?, String?)-> ())
}

struct CurrencyRepository: CurrencyRepositoryInterface {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "parse_queue")
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        self.session = URLSession(configuration: configuration)
        self.baseURL = "https://elementsofdesign.api.stdlib.com/aavia-currency-converter@dev/"
    }
    
    func convertCurrency(amount: Double,
                         isEnabled: Bool,
                         completion: @escaping (Currency?, String?)-> ()) {
        
        let body: [String: Any] = ["amount": amount,
                                   "to_currency": isEnabled ? "EUR" :  "USD",
                                   "from_currency":  isEnabled ? "USD": "EUR"]
        
        guard let request = try? CurrencyRepository.API.convert.urlRequest(params: body, baseURL: baseURL) else {
            completion(nil, "No data")
            return
        }
        
        /// Simulation
//        completion(Currency(), nil)
//        return
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error?.localizedDescription ?? "No data")
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                if let errorMessage = responseJSON["error"] as? [String: String] {
                    let message = errorMessage["message"] ?? "No data"
                    completion(nil, message)
                } else {
                    completion(Currency(json: responseJSON), nil)
                }
            }
        }
        
        task.resume()
    }
}

extension CurrencyRepository {
    enum API {
        case convert
    }
}

extension CurrencyRepository.API: Request {
    var path: String { return "" }
    var method: String { return "POST" }
    var headers: [String: String]? {
        return ["Accept": "application/json",
                "Content-Type" :"application/json"]
    }
}
