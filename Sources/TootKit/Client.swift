//
//  Client.swift
//  TootKit
//
//  Created by Igor Camilo on 15.04.20.
//

import Combine
import Foundation

public final class Client {
    public let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    private func dataTask<T: Decodable>(request: Request, completionHandler: @escaping (Result<T, Error>) -> Void) {
        do {
            try URLSession.shared.dataTask(with: request.urlRequest(with: self)) {
                do {
                    let data = try validate(data: $0, response: $1, error: $2)
                    let value = try globalDecoder.decode(T.self, from: data)
                    completionHandler(.success(value))
                } catch {
                    completionHandler(.failure(error))
                }
            }.resume()
        } catch {
            completionHandler(.failure(error))
        }
    }

    @available(OSX 10.15, *)
    private func dataTaskPublisher<T: Decodable>(request: Request) -> AnyPublisher<T, Error> {
        do {
            return try URLSession.shared
                .dataTaskPublisher(for: request.urlRequest(with: self))
                .tryMap { try validate($0) }
                .decode(type: T.self, decoder: globalDecoder)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

// MARK: Public Timeline

extension Client {
    public func publicTimeline(completionHandler: @escaping (Result<[Status], Error>) -> Void) {
        dataTask(request: .publicTimeline, completionHandler: completionHandler)
    }

    @available(OSX 10.15, *)
    public func publicTimelinePublisher() -> AnyPublisher<[Status], Error> {
        dataTaskPublisher(request: .publicTimeline)
    }
}

// MARK: - Errors

public enum ClientError: Error {
    case invalidResponse(URLResponse?)
    case invalidStatus(Int)
    case noData
}

// MARK: - Private Globals

private let globalDecoder = JSONDecoder()

private let globalEncoder = JSONEncoder()

private func validate(data: Data?, response: URLResponse?, error: Error?) throws -> Data {
    if let error = error { throw error }
    guard let httpResponse = response as? HTTPURLResponse else { throw ClientError.invalidResponse(response) }
    guard 200..<300 ~= httpResponse.statusCode else { throw ClientError.invalidStatus(httpResponse.statusCode) }
    guard let data = data else { throw ClientError.noData }
    return data
}

private func validate(_ dataAndResponse: (Data, URLResponse)) throws -> Data {
    let response = dataAndResponse.1
    guard let httpResponse = response as? HTTPURLResponse else { throw ClientError.invalidResponse(response) }
    guard 200..<300 ~= httpResponse.statusCode else { throw ClientError.invalidStatus(httpResponse.statusCode) }
    return dataAndResponse.0
}
