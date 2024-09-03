// The Swift Programming Language
// https://docs.swift.org/swift-book
public struct CoreNetworking {
    static func performNetworkRequest<T: ApiRequest>(_ request: T, completion: @escaping (Result<T.ResponseType, Error>) -> Void) {
        Networking.shared.performNetworkRequest(request, completion: completion)
    }
}
