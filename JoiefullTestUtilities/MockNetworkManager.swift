//
//  MockNetworkManager.swift
//  JoiefullTestUtilities
//
//  Created by Margot Pasquali on 27/01/2025.
//

import Foundation
import JoiefullService

public final class MockNetworkManager: NetworkManagerProtocol {
    
    private let shouldSucceed: Bool
    private let data: Data?
    private let response: HTTPURLResponse?
    
    public init(shouldSucceed: Bool = true, data: Data? = nil, response: HTTPURLResponse? = FakeResponseData.responseOk) {
        self.shouldSucceed = shouldSucceed
        self.data = data
        self.response = response
    }
    
    public func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        if shouldSucceed {
            return (
                data ?? "{}".data(using: .utf8)!,
                response ?? FakeResponseData.responseOk!
            )
        } else {
            if let response = response {
                switch response.statusCode {
                case 500...599: throw ServiceError.serverError
                case 401: throw ServiceError.unauthorized
                default: throw ServiceError.invalidResponse
                }
            }
            throw ServiceError.serverError
        }
    }
    
}
