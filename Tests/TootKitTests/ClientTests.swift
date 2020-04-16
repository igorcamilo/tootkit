//
//  ClientTests.swift
//  TootKitTests
//
//  Created by Igor Camilo on 16.04.20.
//

import XCTest
@testable import TootKit

final class ClientTests: XCTestCase {
    override class func setUp() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }

    func testPublicTimelineDataTask() throws {
        URLProtocolStub.data = .publicTimeline
        URLProtocolStub.response = try .http()
        let client = try Client.test()

        let expectationDataTask = expectation(description: "Public Timeline Data Task")
        client.publicTimeline { (result) in
            switch result {
            case .success(let statuses):
                print(statuses.count)
            case .failure(let error):
                XCTFail(String(describing: error))
            }
            expectationDataTask.fulfill()
        }

        if #available(OSX 10.15, *) {
            let expectationDataTaskPublisher = expectation(description: "Public Timeline Data Task Publisher")
            _ = client.publicTimelinePublisher().sink(
                receiveCompletion: { (completion) in
                    print("completion", completion)
                    expectationDataTaskPublisher.fulfill()
            },
                receiveValue: { (value) in
                    print("receiveValue", value)
            })
        }

        waitForExpectations(timeout: 10)
    }

    override func tearDown() {
        URLProtocolStub.clear()
    }

    override class func tearDown() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }
}
