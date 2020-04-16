//
//  Defaults.swift
//  TootKitTests
//
//  Created by Igor Camilo on 17.04.20.
//

import Foundation
@testable import TootKit

extension Client {
    static func test() throws -> Client { try Client(baseURL: .baseTest()) }
}

extension URL {
    static func baseTest() throws -> URL {
        guard let baseURL = URL(string: "toot://localhost") else { throw URLError.invalidBaseURL }
        return baseURL
    }
}

extension URLResponse {
    static func http(statusCode: Int = 200, url: URL? = nil) throws -> URLResponse {
        let finalURL = try url ?? .baseTest()
        let header = [
            "Content-Length": "0",
            "Content-Type": "application/json"
        ]
        guard let response = HTTPURLResponse(
            url: finalURL,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: header) else { throw URLError.noURLResponse }
        return response
    }
}

enum URLError: Error {
    case invalidBaseURL
    case noURLResponse
}
