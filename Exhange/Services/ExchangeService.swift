//
//  ExchangeService.swift
//

import Foundation

protocol ExchangeServiceProtocol {
  func fetchRates(for currencies: [String]) async throws -> [TickerResponse]
  func availableCurrencies() async throws -> [String]
}

final class ExchangeService: ExchangeServiceProtocol {
  
  private let client: NetworkClientProtocol
  private let baseURL = "https://api.dolarapp.dev/v1"
  
  private var cachedRates: [TickerResponse]?
  
  init(client: NetworkClientProtocol = NetworkClient()) {
    self.client = client
  }
  
  func fetchRates(for currencies: [String]) async throws -> [TickerResponse] {
    let joined = currencies.joined(separator: ",")
    
    guard let url = URL(string: "\(baseURL)/tickers?currencies=\(joined)") else {
      throw NetworkError.invalidURL
    }
    
    do {
      let rates: [TickerResponse] = try await client.request(url)
      cachedRates = rates
      return rates
    } catch {
      if let cached = cachedRates {
        return cached
      }
      
      return Self.mockRates
    }
  }
  
  func availableCurrencies() async throws -> [String] {
    // TODO: The API is unavailable, we use hardcode
    return ["MXN", "ARS", "BRL", "COP", "EURc"]
  }
  
  // MARK: - Mock Data
  private static let mockRates: [TickerResponse] = [
    TickerResponse(ask: "18.4105000000", bid: "18.4069700000", book: "usdc_mxn", date: ""),
    TickerResponse(ask: "1551.0000000000", bid: "1539.4290300000", book: "usdc_ars", date: ""),
    TickerResponse(ask: "5.4200000000", bid: "5.3800000000", book: "usdc_brl", date: ""),
    TickerResponse(ask: "3832.4200000000", bid: "3800.0000000000", book: "usdc_cop", date: ""),
  ]
  
}
