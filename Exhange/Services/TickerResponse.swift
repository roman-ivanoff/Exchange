//
//  TickerResponse.swift
//

import Foundation

struct TickerResponse: Decodable {
  let ask: String
  let bid: String
  let book: String
  let date: String
  
  var currencyCode: String {
    book.split(separator: "_").last?.uppercased() ?? ""
  }
  
  var askDouble: Double {
    Double(ask) ?? 0
  }
  
  var bidDouble: Double {
    Double(bid) ?? 0
  }
}
