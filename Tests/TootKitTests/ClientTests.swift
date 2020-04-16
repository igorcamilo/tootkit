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

    func testPublicTimeline() {

    }

    override func tearDown() {
        URLProtocolStub.clear()
    }

    override class func tearDown() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }
}
