//
//  CurrencyCell.swift
//

import UIKit

final class CurrencyCell: UITableViewCell {
  
  private enum Layout {
    static let containerSize: CGFloat = 40
    static let containerCornerRadius: CGFloat = 10
    static let flagSize: CGFloat = 28
    static let checkmarkSize: CGFloat = 24
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 8
    static let spacing: CGFloat = 8
  }
  
  static let identifier = "CurrencyCell"
  
  // MARK: - UI Elements
  private lazy var flagImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var flagContainer: UIView = {
    let container = UIView()
    
    container.backgroundColor = UIColor(resource: .borderFloating)
    container.layer.cornerRadius = Layout.containerCornerRadius
    container.clipsToBounds = true
    container.widthAnchor.constraint(equalToConstant: Layout.containerSize).isActive = true
    container.heightAnchor.constraint(equalToConstant: Layout.containerSize).isActive = true
    
    container.addSubview(flagImageView)
    flagImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      flagImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      flagImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      flagImageView.widthAnchor.constraint(equalToConstant: Layout.flagSize),
      flagImageView.heightAnchor.constraint(equalToConstant: Layout.flagSize),
    ])
    
    return container
  }()
  
  private lazy var currencyLabel: UILabel = {
    let label = UILabel()
    label.font = .messinaSans(16)
    label.textColor = UIColor(resource: .contentPrimary)
    return label
  }()
  
  private lazy var checkmarkImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.widthAnchor.constraint(equalToConstant: Layout.checkmarkSize).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: Layout.checkmarkSize).isActive = true
    return imageView
  }()
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    flagImageView.image = nil
    currencyLabel.text = nil
    checkmarkImageView.image = nil
  }
  
  // MARK: - Public
  func configure(flag: String, currency: String, isSelected: Bool) {
    flagImageView.image = UIImage(named: flag)
    currencyLabel.text = currency
    
    if isSelected {
      checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
      checkmarkImageView.tintColor = UIColor(resource: .contentBrand)
    } else {
      checkmarkImageView.image = UIImage(systemName: "circle")
      checkmarkImageView.tintColor = .borderOnSecondary
    }
  }
  
  // MARK: - Setup
  private func setupUI() {
    selectionStyle = .none
    backgroundColor = .clear
    
    let stack = UIStackView(arrangedSubviews: [flagContainer, currencyLabel, UIView(), checkmarkImageView])
    stack.axis = .horizontal
    stack.spacing = Layout.spacing
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(stack)
    
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.verticalPadding),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.verticalPadding),
      stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.horizontalPadding),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.horizontalPadding),
    ])
  }
}
