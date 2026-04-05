//
//  ExchangeViewController.swift
//

import UIKit

final class ExchangeViewController: UIViewController {
  
  private enum Layout {
    static let topInset: CGFloat = 68
    static let horizontalPadding: CGFloat = 16
    static let headerSpacing: CGFloat = 8
    static let sectionSpacing: CGFloat = 24
    static let cardSpacing: CGFloat = 16
    static let swapButtonSize: CGFloat = 30
    static let sheetCornerRadius: CGFloat = 32
  }
  
  // MARK: - Mock Data
  private let topCurrency = "USDc"
  private let bottomCurrency = "MXN"
  private let rate = 18.4097
  private let topAmount = "9,999"
  private let bottomAmount = "184,065.59"
  
  // MARK: - UI Elements
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Exchange calculator"
    label.font = .messinaSans(30, weight: .bold)
    label.textColor = UIColor(resource: .contentPrimary)
    return label
  }()
  
  private lazy var rateLabel: UILabel = {
    let label = UILabel()
    label.text = "1 USDc = 18.4097 MXN"
    label.font = .messinaSans(16)
    label.textColor = UIColor(resource: .contentBrand)
    return label
  }()
  
  private lazy var headerStack: UIStackView = {
    let headerStack = UIStackView(arrangedSubviews: [titleLabel, rateLabel])
    headerStack.axis = .vertical
    headerStack.spacing = Layout.headerSpacing
    return headerStack
  }()
  
  private lazy var topCard = CurrencyCardView(isSelectable: false)
  private lazy var bottomCard = CurrencyCardView(isSelectable: true)
  
  private lazy var swapButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(resource: .swapArrow), for: .normal)
    button.widthAnchor.constraint(equalToConstant: Layout.swapButtonSize).isActive = true
    button.heightAnchor.constraint(equalToConstant: Layout.swapButtonSize).isActive = true
    return button
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupActions()
    configureCards()
  }
  
  // MARK: - Setup
  private func setupUI() {
    view.backgroundColor = UIColor(resource: .bgPrimary)
    setupDismissKeyboardGesture()
    setupLayout()
  }
  
  private func setupLayout() {
    let cardStack = UIStackView(arrangedSubviews: [topCard, bottomCard])
    cardStack.axis = .vertical
    cardStack.spacing = Layout.cardSpacing
    cardStack.translatesAutoresizingMaskIntoConstraints = false
    
    let mainStack = UIStackView(arrangedSubviews: [headerStack, cardStack])
    mainStack.axis = .vertical
    mainStack.spacing = Layout.sectionSpacing
    mainStack.alignment = .center
    mainStack.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(mainStack)
    view.addSubview(swapButton)
    
    swapButton.translatesAutoresizingMaskIntoConstraints = false
    headerStack.translatesAutoresizingMaskIntoConstraints = false
    topCard.translatesAutoresizingMaskIntoConstraints = false
    bottomCard.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.topInset),
      mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalPadding),
      mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
      
      headerStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
      headerStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
      
      topCard.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
      topCard.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
      
      bottomCard.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
      bottomCard.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
      
      swapButton.centerXAnchor.constraint(equalTo: cardStack.centerXAnchor),
      swapButton.centerYAnchor.constraint(equalTo: cardStack.centerYAnchor)
    ])
  }
  
  private func setupActions() {
    bottomCard.onCurrencyTap = { [weak self] in
      self?.showCurrencyPicker()
    }
  }
  
  private func configureCards() {
    topCard.configure(flag: "usdc", currency: topCurrency, amount: topAmount)
    bottomCard.configure(flag: "mxn", currency: bottomCurrency, amount: bottomAmount)
  }
  
  // MARK: - Actions
  private func showCurrencyPicker() {
    let pickerVC = CurrencyPickerViewController()
    if let sheet = pickerVC.sheetPresentationController {
      sheet.detents = [.medium()]
      sheet.prefersGrabberVisible = true
      sheet.preferredCornerRadius = Layout.sheetCornerRadius
    }
    
    present(pickerVC, animated: true)
  }
}

