//
//  MainTabBarController.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 16/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Overridden methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = UIColor.firstColor
    }
}
