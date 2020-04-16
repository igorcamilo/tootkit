//
//  RequestTests.swift
//  TootKitTests
//
//  Created by Igor Camilo on 16.04.20.
//

import XCTest
@testable import TootKit

final class RequestTests: XCTestCase {
    private func urlRequest(with request: Request) throws -> URLRequest { try request.urlRequest(with: .test()) }

    func testPublicTimeline() throws {
        let urlRequest = try self.urlRequest(with: .publicTimeline)
        XCTAssertEqual(urlRequest.url?.absoluteString, "toot://localhost/api/v1/timelines/public")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
    }
}
