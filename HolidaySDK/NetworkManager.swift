//
//  NetworkManager.swift
//  HolidaySDK
//
//  Created by Son Hoang Duc on 15/2/25.
//
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let calendarificAPIKey = "hqIkhziiW53oxxF5PYgq5zrGH1az8G3G"
    private let abstractAPIKey = "577a525c42594b58ad6157d07d355c0f"
//    private let holidayAPIKey = ""
    private init() {}
    
    func fetchDataFromCalendarific(year: Int, month: Int, day: Int, completion: @escaping (Result<Bool, HolidayError>) -> Void) {
        let urlString = "https://calendarific.com/api/v2/holidays?api_key=\(calendarificAPIKey)&country=US&year=\(year)"
        performRequest(url: urlString, completion: completion)
    }
    
    func fetchDataFromAbstractAPI(year: Int, month: Int, day: Int, completion: @escaping (Result<Bool, HolidayError>) -> Void) {
        let urlString = "https://holidays.abstractapi.com/v1/?api_key=\(abstractAPIKey)&country=US&year=\(year)"
        performRequest(url: urlString, completion: completion)
    }
    
    private func performRequest(url: String, completion: @escaping (Result<Bool, HolidayError>) -> Void) {
        guard let requestURL = URL(string: url) else {
            completion(.failure(.networkError("Invalid URL")))
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code \(httpResponse.statusCode)")
            }
            
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print("Response data: \(jsonString)")
            }
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            let isHoliday = Bool.random()
            completion(.success(isHoliday))
        }
        task.resume()
    }
}
