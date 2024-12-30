//
//  NetworkManager.swift
//  JoiefullService
//
//  Created by Margot Pasquali on 19/12/2024.
//

import Foundation

// MARK: - NetworkManagerProtocol
public protocol NetworkManagerProtocol {
    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

// MARK: - NetworkManager
public final class NetworkManager: NetworkManagerProtocol {

    // MARK: - Properties
    private var urlSession: URLSession

    // MARK: - Initializer
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    // MARK: - Public Methods
    public func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let customRequest = request

        // MARK: Debugging Logs
        print("Sending request to URL: \(customRequest.url?.absoluteString ?? "No URL")")
        print("Request method: \(customRequest.httpMethod ?? "No method")")
        if let headers = customRequest.allHTTPHeaderFields {
            print("Request headers: \(headers)")
        }
        if let body = customRequest.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Request body: \(bodyString)")
        } else {
            print("No request body")
        }

        do {
            let (data, response) = try await urlSession.data(for: customRequest, delegate: nil)

            // MARK: Response Handling
            guard let response = response as? HTTPURLResponse else {
                print("Invalid response received")
                throw ServiceError.invalidResponse
            }

            print("Received HTTP response with status code: \(response.statusCode)")
            if let responseData = String(data: data, encoding: .utf8) {
                print("Response data: \(responseData)")
            } else {
                print("Unable to decode response data as string")
            }

            switch response.statusCode {
            case 200...299:
                // Success case for codes 200 to 299, including 201
                return (data, response)
            case 401:
                print("Unauthorized (401) response received")
                throw ServiceError.unauthorized
            case 500...599:
                print("Server error (5xx) response received: \(response.statusCode)")
                throw ServiceError.serverError
            default:
                print("Unexpected HTTP status code received: \(response.statusCode)")
                throw ServiceError.invalidResponse
            }
        } catch let error as URLError {
            print("Caught URLError: \(error)")
            throw ServiceError.networkError(error)
        } catch {
            print("Caught generic error: \(error)")
            throw ServiceError.networkError(error)
        }
    }
}
