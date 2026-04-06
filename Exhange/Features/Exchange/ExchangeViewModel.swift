//
//  ExchangeViewModel.swift
//

import Foundation

final class ExchangeViewModel {
  
  // MARK: Public Properties
  var onStateChanged: ((ExchangeViewState) -> Void)?
  
  private(set) var state: ExchangeViewState
  
  // MARK: Private Properties
  private var sourceCurrency: Currency
  private var targetCurrency: Currency
  private var sourceAmount: Double
  private var rate: Double
  private var isSwapped: Bool
  
  // MARK: - Mock Data
  private let availableCurrencies = [
    Currency(code: "ARS", flag: "ars"),
    Currency(code: "EURc", flag: "eurc"),
    Currency(code: "COP", flag: "cop"),
    Currency(code: "MXN", flag: "mxn"),
    Currency(code: "BRL", flag: "brl"),
  ]
  
  // MARK: - Init
  init() {
    sourceCurrency = Currency(code: "USDc", flag: "usdc")
    targetCurrency = Currency(code: "MXN", flag: "mxn")
    sourceAmount = 9999
    rate = 18.4097
    isSwapped = false
    
    state = ExchangeViewState(
      sourceCurrency: sourceCurrency,
      targetCurrency: targetCurrency,
      sourceAmount: CurrencyFormatter.format(sourceAmount),
      targetAmount: CurrencyFormatter.format(sourceAmount * rate),
      rateText: "1 USDc = 18.4097 MXN",
      isSwapped: false
    )
  }
  
  // MARK: - Actions
  func updateSourceAmount(_ amount: Double) {
    sourceAmount = amount
    updateState()
  }
  
  func swap() {
    isSwapped.toggle()
    let temp = sourceCurrency
    sourceCurrency = targetCurrency
    targetCurrency = temp
    updateState()
  }
  
  func selectCurrency(_ currency: Currency) {
    if isSwapped {
      sourceCurrency = currency
    } else {
      targetCurrency = currency
    }
    updateState()
  }
  
  // MARK: - Private Methods
  private func updateState() {
    let targetAmount = sourceAmount * rate
    let rateText = "1 \(sourceCurrency.code) = \(rate) \(targetCurrency.code)"
    
    state = ExchangeViewState(
      sourceCurrency: sourceCurrency,
      targetCurrency: targetCurrency,
      sourceAmount: CurrencyFormatter.format(sourceAmount),
      targetAmount: CurrencyFormatter.format(targetAmount),
      rateText: rateText,
      isSwapped: isSwapped
    )
    
    onStateChanged?(state)
  }
  
}
