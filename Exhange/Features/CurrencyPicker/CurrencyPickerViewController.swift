//
//  CurrencyPickerViewController.swift
//

import UIKit

final class CurrencyPickerViewController: UIViewController {
  
  private enum Layout {
    static let topInset: CGFloat = 24
    static let horizontalPadding: CGFloat = 16
    static let bottomInset: CGFloat = 32
    static let tableTopSpacing: CGFloat = 16
    static let tableCornerRadius: CGFloat = 16
    static let tableVerticalInset: CGFloat = 2
    static let rowHeight: CGFloat = 62
  }
  
  var onCurrencySelected: ((Currency) -> Void)?
  
  // MARK: - Mock Data
  
  private let currencies: [Currency] = [
    Currency(code: "ARS", flag: "ars"),
    Currency(code: "COP", flag: "cop"),
    Currency(code: "MXN", flag: "mxn"),
    Currency(code: "BRL", flag: "brl"),
  ]
  
  private var selectedCurrency: Currency
  
  init(selectedCurrency: Currency) {
    self.selectedCurrency = selectedCurrency
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Elements
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Choose currency"
    label.font = .messinaSans(24, weight: .semibold)
    label.textColor = UIColor(resource: .contentPrimary)
    return label
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton()
    let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
    button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
    button.tintColor = UIColor(resource: .contentPrimary)
    button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var tableView: UITableView = {
    let table = UITableView()
    table.delegate = self
    table.dataSource = self
    table.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.identifier)
    table.separatorStyle = .none
    table.rowHeight = Layout.rowHeight
    table.backgroundColor = .bgSecondary
    table.layer.cornerRadius = Layout.tableCornerRadius
    table.contentInset = UIEdgeInsets(top: Layout.tableVerticalInset, left: 0, bottom: Layout.tableVerticalInset, right: 0)
    return table
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  // MARK: - Setup
  private func setupUI() {
    view.backgroundColor = .bgPrimary
    
    titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    closeButton.setContentHuggingPriority(.required, for: .horizontal)
    
    let headerStack = UIStackView(arrangedSubviews: [titleLabel, closeButton])
    headerStack.axis = .horizontal
    headerStack.alignment = .center
    headerStack.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(headerStack)
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      headerStack.topAnchor.constraint(equalTo: view.topAnchor, constant: Layout.topInset),
      headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalPadding),
      headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
      
      tableView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: Layout.tableTopSpacing),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalPadding),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layout.bottomInset),
    ])
  }
  
  // MARK: - Actions
  @objc private func closeTapped() {
    dismiss(animated: true)
  }
}

// MARK: - UITableViewDataSource
extension CurrencyPickerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    currencies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.identifier, for: indexPath) as! CurrencyCell
    let currency = currencies[indexPath.row]
    let isSelected = currency.code == selectedCurrency.code
    cell.configure(flag: currency.flag, currency: currency.code, isSelected: isSelected)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CurrencyPickerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedCurrency = currencies[indexPath.row]
    tableView.reloadData()
    
    onCurrencySelected?(currencies[indexPath.row])
    dismiss(animated: true)
  }
}
