//
//  MockNetworkClient.swift
//

import Foundation

final class MockNetworkClient: NetworkClientProtocol {
  var mockData: Data?
  var mockError: NetworkError?
  
  func request<T: Decodable >(_ url: URL) async throws -> T {
    if let error = mockError {
      throw error
    }
    
    guard let data = mockData else {
      throw NetworkError.noData
    }
    
    return try JSONDecoder().decode(T.self, from: data)
  }
}
