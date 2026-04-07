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
  
  // MARK: - Properties
  private let viewModel: ExchangeViewModel
  
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
  
  // MARK: - Init
  init(viewModel: ExchangeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupActions()
    bindViewModel()
    updateUI(viewModel.state)
    viewModel.loadData()
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
    
    topCard.onAmountChanged = { [weak self] text in
      self?.viewModel.updateSourceAmount(text)
    }
    
    bottomCard.onAmountChanged = { [weak self] text in
      self?.viewModel.updateTargetAmount(text)
    }
  }
  
  private func bindViewModel() {
    viewModel.onStateChanged = { [weak self] state in
      self?.updateUI(state)
    }
  }
  
  private func updateUI(_ state: ExchangeViewState) {
    rateLabel.text = state.rateText
    
    switch viewModel.activeField {
    case .source:
      bottomCard.configure(flag: state.targetCurrency.flag, currency: state.targetCurrency.code, amount: state.targetAmount)
    case .target:
      topCard.configure(flag: state.sourceCurrency.flag, currency: state.sourceCurrency.code, amount: state.sourceAmount)
    case nil:
      topCard.configure(flag: state.sourceCurrency.flag, currency: state.sourceCurrency.code, amount: state.sourceAmount)
      bottomCard.configure(flag: state.targetCurrency.flag, currency: state.targetCurrency.code, amount: state.targetAmount)
    }
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

