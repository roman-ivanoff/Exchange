//
//  ExchangeViewState.swift
//

import Foundation

struct ExchangeViewState {
  let sourceCurrency: Currency
  let targetCurrency: Currency
  let sourceAmount: String
  let targetAmount: String
  let rateText: String
  let isSwapped: Bool
  let activeField: ActiveField?
}
