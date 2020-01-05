
//
//  SettingsViewController.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 04/01/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var viewModel: SettingsViewModel

    init?(coder: NSCoder, viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
