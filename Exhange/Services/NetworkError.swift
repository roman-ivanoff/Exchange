//
//  NetworkError.swift
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case noData
  case decodingFailed
  case serverError(statusCode: Int)
  case unknown(Error)
}
