//
//  HolidaySDKTests.swift
//  HolidaySDKTests
//
//  Created by Son Hoang Duc on 15/2/25.
//

import XCTest
@testable import HolidaySDK

final class HolidaySDKTests: XCTestCase {
    var holidayChecker: HolidayChecker!
    
    override func setUp() {
        super.setUp()
        holidayChecker = HolidayChecker()
    }
    
    override func tearDown() {
        holidayChecker = nil
        super.tearDown()
    }
    
    func testHoliday_ValidHoliday() {
        let expectation = self.expectation(description: "Valid holiday checking")
        
        holidayChecker.isHoliday(year: 2025, month: 12, day: 25, mode: .any) { result in
            switch result {
            case .success(let isHoliday):
                XCTAssertTrue(isHoliday, "Expected Chrismas is a holiday")
            case .failure(let failure):
                XCTFail("Unexpected error: \(failure)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testHoliday_InvalidDate() {
        let expectation = self.expectation(description: "Invalid date checking")
        
        holidayChecker.isHoliday(year: 2025, month: 1, day: 33, mode: .any) { result in
            switch result {
            case .success:
                XCTFail("Invalid date")
            case .failure(let failure):
                XCTAssertNotNil(failure, "Error occur for invalid date")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testHoliday_NetworkCheck() {
        let expectation = self.expectation(description: "Network failure check")
        
        holidayChecker.isHoliday(year: 2025, month: 16, day: 2, mode: .all) { result in
            switch result {
            case .success:
                XCTFail("Expect fail for network issue")
            case .failure(let failure):
                XCTAssertNotNil(failure, "Expect fail for network issue")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
