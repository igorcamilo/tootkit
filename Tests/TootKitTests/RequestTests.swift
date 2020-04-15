//
//  RequestTests.swift
//  TootKitTests
//
//  Created by Igor Camilo on 16.04.20.
//

import XCTest
@testable import TootKit

final class RequestTests: XCTestCase {
    func testURLRequest() {
        guard let baseURL =  URL(string: "toot://localhost") else {
            XCTFail("Can't create base URL")
            return
        }
        let client = Client(baseURL: baseURL)

        let publicTimelineURLRequest = Request.publicTimeline.urlRequest(with: client)
        XCTAssertEqual(publicTimelineURLRequest.url, URL(string: "toot://localhost/timelines/public"))
        XCTAssertEqual(publicTimelineURLRequest.httpMethod, "GET")
    }
}
