//
//  HolidayChecker.swift
//  HolidaySDK
//
//  Created by Son Hoang Duc on 15/2/25.
//
import Foundation

public enum HolidayMode {
    case any, all, consensus
}

public enum HolidayError: Error {
    case invalidDate
    case networkError(String)
    case apiLimit
    case unknown
}

public class HolidayChecker {
    public init() {}
    
    public func isHoliday(year: Int, month: Int, day: Int, mode: HolidayMode, completion: @escaping (Result<Bool, HolidayError>) -> Void) {
        print("Checking holiday for \(year)-\(month)-\(day) using mode \(mode)")
        guard year >= 0, year < 3000, month >= 1, month <= 12, day >= 1, day <= 31 else {
            completion(.failure(.invalidDate))
            return
        }
        
        fetchHolidayData(year: year, month: month, day: day) { results in
            switch results {
            case .success(let holidays):
                let decision = self.processResult(holidays, mode: mode)
                completion(.success(decision))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchHolidayData(year: Int, month: Int, day: Int, completion: @escaping (Result<[Bool], HolidayError>) -> Void) {
        let group = DispatchGroup()
        var results: [Bool] = []
        var errorOccur: HolidayError?
        
        group.enter()
        NetworkManager.shared.fetchDataFromCalendarific(year: year, month: month, day: day) { result in
            if case .success(let isHoliday) = result {
                results.append(isHoliday)
            }else if case .failure(let error) = result {
                errorOccur = error
            }
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.fetchDataFromAbstractAPI(year: year, month: month, day: day) { result in
            if case .success(let isHoliday) = result {
                results.append(isHoliday)
            }else if case .failure(let error) = result {
                errorOccur = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if !results.isEmpty {
                completion(.success(results))
            }else {
                completion(.failure(errorOccur ?? .unknown))
            }
        }
    }
    
    private func processResult(_ results: [Bool], mode: HolidayMode) -> Bool {
        switch mode {
        case .any:
            return results.contains(true)
        case .all:
            return !results.contains(false)
        case .consensus:
            let trueCount = results.filter {$0}.count
            return trueCount > results.count / 2
        }
    }
}
