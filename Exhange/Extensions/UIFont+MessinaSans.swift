//
//  UIFont+MessinaSans.swift
//

import UIKit

extension UIFont {
  static func messinaSans(_ size: CGFloat, weight: Weight = .semibold) -> UIFont {
    let name: String
    
    switch weight {
    case .semibold:
      name = "MessinaSans-SemiBold"
    case .bold:
      name = "MessinaSans-Bold"
    default:
      name = "MessinaSans-SemiBold"
    }
    
    return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: weight)
  }
}
