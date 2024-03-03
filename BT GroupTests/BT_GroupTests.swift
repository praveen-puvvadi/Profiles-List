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
        super.tearDown()
        controller = nil
        apiManager = nil
    }
    
    func testRightGestureReponse() {
        let rightGesture = UISwipeGestureRecognizer()
        rightGesture.direction = .right
        controller.respondToSwipeGesture(gesture: rightGesture)
    }
    
    func testLeftGestureReponse() {
        let leftGesture = UISwipeGestureRecognizer()
        leftGesture.direction = .left
        controller.respondToSwipeGesture(gesture: leftGesture)
    }

    func testAPICallSuccess() {
        let expectation = XCTestExpectation(description: "API call should succeed")
        apiManager.networkingAPIHandler(urlString: Constants.getUserProfiles+"\(1)", completion: { status, profiles, error in
            switch status {
            case true:
                XCTAssertNotNil(profiles)
                expectation.fulfill()
            case false:
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }
        })
    }

    func testAPICallFailure() {
        let expectation = XCTestExpectation(description: "API call should fail")
        apiManager.networkingAPIHandler(urlString: Constants.getUserProfiles+"\(3)", completion: { status, profiles, error in
            switch status {
            case true:
                XCTFail("API call failed with error: \(error.localizedDescription)")
            case false:
                XCTAssertNotNil(profiles)
                expectation.fulfill()
            }
        })
    }
    
    func testSwipeGestureAPI() {
        controller.makeSwipeAPICall(page: 1)
    }
    
    func testMakeAPICallInSwipe() {
        apiManager.makeAPICallInSwipe(page: 1) {
            //
        }
    }
    
    func testToastLabel() {
        controller.showToastLabel(message: "Please check your internet connection!")
    }
    
//    func testShowToastMessage(message: String) {
//        controller.showToastMessage(message: "Testing Toast Label")
//    }
}
