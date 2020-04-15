//
//  RequestTests.swift
//  TootKitTests
//
//  Created by Igor Camilo on 16.04.20.
//

import XCTest
@testable import TootKit

final class RequestTests: XCTestCase {
    private func urlRequest(with request: Request) -> URLRequest {
        request.urlRequest(with: Client(baseURL: URL(string: "toot://localhost")!))
    }

    func testPublicTimeline() {
        let urlRequest = self.urlRequest(with: .publicTimeline)
        XCTAssertEqual(urlRequest.url?.absoluteString, "toot://localhost/api/v1/timelines/public")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
    }
}
