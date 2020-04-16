//
//  URLProtocolStub.swift
//  TootKitTests
//
//  Created by Igor Camilo on 16.04.20.
//

import Foundation

final class URLProtocolStub: URLProtocol {
    static var data: Data?
    static var response: URLResponse?

    class func clear() {
        data = nil
        response = nil
    }

    override class func canInit(with request: URLRequest) -> Bool { request.url?.scheme == "toot" }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let response = Self.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        }
        if let data = Self.data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
