//
//  NetworkClient.swift
//

import Foundation

protocol NetworkClientProtocol {
  func request<T: Decodable>(_ url: URL) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
  
  private let session: URLSession
  private let decoder: JSONDecoder
  
  init(session: URLSession = .shared) {
    self.session = session
    self.decoder = JSONDecoder()
  }
  
  func request<T: Decodable>(_ url: URL) async throws -> T {
    let (data, response) = try await session.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.noData
    }
    
    guard (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.serverError(statusCode: httpResponse.statusCode)
    }
    
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      throw NetworkError.decodingFailed
    }
  }
  
}
