//
//  Request.swift
//  TootKit
//
//  Created by Igor Camilo on 16.04.20.
//

import Foundation

enum Request {
    case publicTimeline
}

extension Request {
    func urlRequest(with client: Client) -> URLRequest {
        var urlRequest = URLRequest(url: client.baseURL.appendingPathComponent("api/v1"))
        switch self {
        case .publicTimeline:
            urlRequest.url?.appendPathComponent("timelines/public")
        }
        return urlRequest
    }
}
