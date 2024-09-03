//
//  Networking.swift
//  PayPay_CurrencyConversion
//
//  Created by Mohindra Bhati on 04/06/24.
//

import Foundation

public protocol BaseNetworkProtocol {
    func performNetworkRequest<T: ApiRequest>(_ request: T, completion: @escaping (Result<T.ResponseType, Error>) -> Void)
}

public final class Networking: BaseNetworkProtocol {
    public static let shared = Networking()
    private init() {}
    
    public func performNetworkRequest<T: ApiRequest>(_ request: T, completion: @escaping (Result<T.ResponseType, Error>) -> Void) {
        var urlRequest = URLRequest(url: request.urlWithQueries())
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.ResponseType.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
