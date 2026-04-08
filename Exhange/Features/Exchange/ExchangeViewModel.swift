//
//  ExchangeViewModel.swift
//

import Foundation

enum ActiveField {
  case source
  case target
}

final class ExchangeViewModel {
  
  // MARK: Public Properties
  var onStateChanged: ((ExchangeViewState) -> Void)?
  var onError: ((String) -> Void)?
  
  private(set) var state: ExchangeViewState
  private(set) var activeField: ActiveField? = nil
  
  // MARK: Private Properties
  private let service: ExchangeServiceProtocol
  private var sourceCurrency: Currency
  private var targetCurrency: Currency
  private var sourceAmount: Double
  private var rates: [TickerResponse] = []
  private var isSwapped: Bool
  private var availableCurrencies: [String] = []
  private var targetAmount: Double = 0
  
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
      isSwapped: false,
      activeField: nil
    )
  }
  
  // MARK: - Public Methods
  func loadData() {
    Task {
      do {
        availableCurrencies = try await service.availableCurrencies()
        rates = try await service.fetchRates(for: availableCurrencies)
        await MainActor.run {
          activeField = nil
          updateState()
        }
      } catch {
        await MainActor.run {
          onError?("Failed to load rates")
        }
      }
    }
  }
  
  func updateSourceAmount(_ text: String) {
    activeField = .source
    sourceAmount = parseAmount(text)
    let rate = currentRate()
    
    if isSwapped {
      targetAmount = rate > 0 ? sourceAmount / rate : 0
    } else {
      targetAmount = sourceAmount * rate
    }
    
    updateState()
  }
  
  // The user has entered an amount in the bottom field
  func updateTargetAmount(_ text: String) {
    activeField = .target
    targetAmount = parseAmount(text)
    
    let rate = currentRate()
    
    if isSwapped {
      sourceAmount = targetAmount * rate
    } else {
      sourceAmount = rate > 0 ? targetAmount / rate : 0
    }
    
    updateState()
  }
  
  func swap() {
    isSwapped.toggle()
    let temp = sourceCurrency
    sourceCurrency = targetCurrency
    targetCurrency = temp
    
    let tempAmount = sourceAmount
    sourceAmount = targetAmount
    targetAmount = tempAmount
    
    activeField = nil
    updateState()
  }
  
  func selectCurrency(_ currency: Currency) {
    if isSwapped {
      sourceCurrency = currency
    } else {
      targetCurrency = currency
    }
    
    let rate = currentRate()
    
    if isSwapped {
      targetAmount = rate > 0 ? sourceAmount / rate : 0
    } else {
      targetAmount = sourceAmount * rate
    }
    
    activeField = nil
    updateState()
  }
  
  // MARK: - Private Methods
  private func currentRate() -> Double {
    let code: String
    
    if sourceCurrency.code == "USDc" {
      code = targetCurrency.code
    } else {
      code = sourceCurrency.code
    }
    
    return rates.first { $0.currencyCode == code.uppercased() }?.askDouble ?? 0
  }
  
  private func updateState() {
    let rate = currentRate()
    
    let rateText: String
    
    if rate > 0 {
      if isSwapped {
        let inverseRate = 1.0 / rate
        rateText = "1 \(sourceCurrency.code) = \(CurrencyFormatter.formatRate(inverseRate)) \(targetCurrency.code)"
      } else {
        rateText = "1 \(sourceCurrency.code) = \(rate) \(targetCurrency.code)"
      }
    } else {
      rateText = ""
    }
    
    state = ExchangeViewState(
      sourceCurrency: sourceCurrency,
      targetCurrency: targetCurrency,
      sourceAmount: sourceAmount > 0 ? CurrencyFormatter.format(sourceAmount) : "",
      targetAmount: targetAmount > 0 ? CurrencyFormatter.format(targetAmount) : "",
      rateText: rateText,
      isSwapped: isSwapped,
      activeField: activeField
    )
    
    onStateChanged?(state)
  }
  
  // Parsing a string into a number (removing $ and commas)
  private func parseAmount(_ text: String) -> Double {
    let cleaned = text
      .replacingOccurrences(of: "$", with: "")
      .replacingOccurrences(of: ",", with: ".")
      .trimmingCharacters(in: .whitespaces)
    
    return Double(cleaned) ?? 0
  }
  
}
