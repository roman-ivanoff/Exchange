//
//  ExchangeViewModel.swift
//

import Foundation

final class ExchangeViewModel {
  
  // MARK: Public Properties
  var onStateChanged: ((ExchangeViewState) -> Void)?
  var onError: ((String) -> Void)?
  
  private(set) var state: ExchangeViewState
  
  // MARK: Private Properties
  private let service: ExchangeServiceProtocol
  private var sourceCurrency: Currency
  private var targetCurrency: Currency
  private var sourceAmount: Double
  private var rates: [TickerResponse] = []
  private var isSwapped: Bool
  private var availableCurrencies: [String] = []
  
  // MARK: - Init
  init(service: ExchangeServiceProtocol = ExchangeService()) {
    self.service = service
    sourceCurrency = Currency(code: "USDc", flag: "usdc")
    targetCurrency = Currency(code: "MXN", flag: "mxn")
    sourceAmount = 0
    isSwapped = false
    
    state = ExchangeViewState(
      sourceCurrency: sourceCurrency,
      targetCurrency: targetCurrency,
      sourceAmount: "",
      targetAmount: "",
      rateText: "",
      isSwapped: false
    )
  }
  
  // MARK: - Public Methods
  func loadData() {
    Task {
      do {
        availableCurrencies = try await service.availableCurrencies()
        rates = try await service.fetchRates(for: availableCurrencies)
        await MainActor.run {
          updateState()
        }
      } catch {
        await MainActor.run {
          onError?("Failed to load rates")
        }
      }
    }
  }
  
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
  private func currentRate() -> Double {
    let code = isSwapped ? sourceCurrency.code : targetCurrency.code
    return rates.first { $0.currencyCode == code.uppercased() }?.askDouble ?? 0
  }
  
  private func updateState() {
    let rate = currentRate()
    let targetAmount: Double
    
    if isSwapped {
      targetAmount = rate > 0 ? sourceAmount / rate : 0
    } else {
      targetAmount = sourceAmount * rate
    }
    
    let rateText: String
    
    if rate > 0 {
      rateText = "1 \(sourceCurrency.code) = \(rate) \(targetCurrency.code)"
    } else {
      rateText = ""
    }
    
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
