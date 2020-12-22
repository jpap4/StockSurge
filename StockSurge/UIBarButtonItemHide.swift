//
//  UIBarButtonItemHide.swift
//  StockSurge
//
//  Created by John Pappas on 12/21/20.
//  Copyright © 2020 John Pappas. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}

extension UISearchBar {
    func hide() {
        self.alpha = 0.0
        self.tintColor = .clear
    }
}

extension UILabel {
    func hide() {
        self.alpha = 0.0
    }
}

extension UIButton {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
        self.alpha = 0.0
    }
}

extension UITableView {
    func hide() {
        self.isHidden = true
    }
}
