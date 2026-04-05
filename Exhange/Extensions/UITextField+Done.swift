//
//  UITextField+Done.swift
//

import UIKit

extension UITextField {
  func addDoneButton() {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
    toolbar.items = [spacer, done]
    inputAccessoryView = toolbar
  }
}
