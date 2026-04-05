//
//  UIViewController+Keyboard.swift
//

import UIKit

extension UIViewController {
  func setupDismissKeyboardGesture() {
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
}
