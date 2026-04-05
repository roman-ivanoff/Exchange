//
//  CurrencyCardView.swift
//

import UIKit

final class CurrencyCardView: UIView {
  private enum Layout {
    static let cornerRadius: CGFloat = 16
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 23
  }
  
  // MARK: - Properties
  private(set) var isSelectable: Bool
  var onCurrencyTap: (() -> Void)?
  
  // MARK: - UI Elements
  private lazy var flagImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
    return imageView
  }()
  
  private lazy var currencyLabel: UILabel = {
    let label = UILabel()
    label.font = .messinaSans(16)
    label.textColor = UIColor(resource: .contentPrimary)
    return label
  }()
  
  private lazy var chevronImageView: UIImageView = {
    let imageView = UIImageView()
    let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
    imageView.image = UIImage(systemName: "chevron.down", withConfiguration: config)
    imageView.tintColor = UIColor(resource: .contentPrimary)
    imageView.contentMode = .scaleAspectFit
    imageView.isHidden = !isSelectable
    return imageView
  }()
  
  private lazy var amountTextField: UITextField = {
    let textField = UITextField()
    textField.font = .messinaSans(16, weight: .bold)
    textField.textColor = UIColor(resource: .contentPrimary)
    textField.textAlignment = .right
    textField.keyboardType = .decimalPad
    textField.addDoneButton()
    return textField
  }()
  
  private lazy var currencyStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [flagImageView, currencyLabel, chevronImageView])
    stack.axis = .horizontal
    stack.spacing = 8
    stack.alignment = .center
    stack.isUserInteractionEnabled = true
    return stack
  }()
  
  // MARK: - Init
  init(isSelectable: Bool) {
    self.isSelectable = isSelectable
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public
  func configure(flag: String, currency: String, amount: String) {
    flagImageView.image = UIImage(named: flag)
    currencyLabel.text = currency
    amountTextField.text = amount
  }
  
  func setSelectable(_ selectable: Bool) {
    isSelectable = selectable
    chevronImageView.isHidden = !selectable
  }
  
  // MARK: - Setup
  private func setupUI() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(currencyTapped))
    currencyStack.addGestureRecognizer(tap)
    
    backgroundColor = UIColor(resource: .bgSecondary)
    layer.cornerRadius = Layout.cornerRadius
    clipsToBounds = true
    
    let cardStack = UIStackView(arrangedSubviews: [currencyStack, amountTextField])
    cardStack.axis = .horizontal
    cardStack.alignment = .center
    cardStack.translatesAutoresizingMaskIntoConstraints = false
    cardStack.distribution = .equalSpacing
    
    addSubview(cardStack)
    
    NSLayoutConstraint.activate([
      cardStack.topAnchor.constraint(equalTo: topAnchor, constant: Layout.verticalPadding),
      cardStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Layout.verticalPadding),
      cardStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.horizontalPadding),
      cardStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.horizontalPadding),
    ])
  }
  
  @objc private func currencyTapped() {
    guard isSelectable else { return }
    onCurrencyTap?()
  }
}
