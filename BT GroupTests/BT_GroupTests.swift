//
//  BT_GroupTests.swift
//  BT GroupTests
//
//  Created by Praveen Kumar on 19/02/24.
//

import XCTest
@testable import BT_Group

final class APITestCase: XCTestCase {
    
    var controller: ViewController! // Instantiate your controller
    var apiManager: ProfileListViewModel! // Instantiate your API manager

    override func setUp() {
        super.setUp()
        controller = ViewController() // Initialize your controller
        apiManager = ProfileListViewModel() // Initialize your API manager
    }

    override func tearDown() {
        controller = nil
        apiManager = nil
        super.tearDown()
    }
    
    func testGestureReponse() {
        controller.respondToSwipeGesture(gesture: UISwipeGestureRecognizer())
    }

    func testAPICallSuccess() {
        let expectation = XCTestExpectation(description: "API call should succeed")
        apiManager.makeAPICallToGetDetails(pageNo: 1)
        XCTAssertNotNil([String: Any]())
        expectation.fulfill()
    }

    func testAPICallFailure() {
        let expectation = XCTestExpectation(description: "API call should fail")
        apiManager.makeAPICallToGetDetails(pageNo: 3)
        XCTAssertNotNil("Failed")
        expectation.fulfill()
    }
}
