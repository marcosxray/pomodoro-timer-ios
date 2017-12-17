//
//  BaseViewController.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 16/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Overridden methods

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
