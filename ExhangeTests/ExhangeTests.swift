//
//  ExhangeTests.swift
//

import XCTest

@testable import Exhange
@MainActor
final class ExhangeViewModelTests: XCTestCase {

  private var viewModel: ExchangeViewModel!
  
  override func setUp() {
    super.setUp()
    let mockClient = MockNetworkClient()
    let service = ExchangeService(client: mockClient)
    viewModel = ExchangeViewModel(service: service)
  }
  
  func testEmptyInput() {
    viewModel.updateSourceAmount("")
    XCTAssertEqual(viewModel.state.sourceAmount, "")
    XCTAssertEqual(viewModel.state.targetAmount, "")
  }
  
  func testZeroInput() {
    viewModel.updateSourceAmount("0")
    XCTAssertEqual(viewModel.state.sourceAmount, "")
    XCTAssertEqual(viewModel.state.targetAmount, "")
  }
  
  func testNormalInput() {
    viewModel.loadData()
    
    let expectation = expectation(description: "Load data")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.viewModel.updateSourceAmount("100")
      XCTAssertFalse(self.viewModel.state.targetAmount.isEmpty)
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testSwap() {
    viewModel.loadData()
    
    let expectation = expectation(description: "Load data")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.viewModel.updateSourceAmount("100")
      let beforeSwap = self.viewModel.state.sourceCurrency.code
      
      self.viewModel.swap()
      let afterSwap = self.viewModel.state.targetCurrency.code
      
      XCTAssertEqual(beforeSwap, afterSwap)
      expectation.fulfill()
    }
      
    wait(for: [expectation], timeout: 5)
  }
  
  func testLargeNumber() {
    viewModel.loadData()
    
    let expectation = expectation(description: "Load data")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.viewModel.updateSourceAmount("999999999")
      XCTAssertFalse(self.viewModel.state.targetAmount.isEmpty)
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testGarbageInput() {
    viewModel.updateSourceAmount("abc")
    XCTAssertEqual(viewModel.state.sourceAmount, "")
    XCTAssertEqual(viewModel.state.targetAmount, "")
  }
  
  func testSelectCurrency() {
    viewModel.loadData()
    
    let expectation = expectation(description: "Load data")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      let cop = Currency(code: "COP", flag: "cop")
      self.viewModel.selectCurrency(cop)
      XCTAssertEqual(self.viewModel.state.targetCurrency.code, "COP")
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 5)
  }
}
