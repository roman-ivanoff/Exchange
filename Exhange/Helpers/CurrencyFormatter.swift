//
//  CurrencyFormatter.swift
//

import Foundation

enum CurrencyFormatter {
  static func format(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.groupingSeparator = ","
    let formatted = formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    return "$\(formatted)"
  }
  
  static func formatRate(_ rate: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 4
    return formatter.string(from: NSNumber(value: rate)) ?? "0.00"
  }
}
