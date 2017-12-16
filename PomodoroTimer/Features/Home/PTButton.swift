//
//  PTButton.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 15/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import UIKit

class PTButton: UIButton {

    // MARK: IBInspectable variables
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
