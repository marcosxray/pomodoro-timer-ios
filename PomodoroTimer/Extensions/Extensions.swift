//
//  Extensions.swift
//  PomodoroTimer
//
//  Created by retina on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import UIKit

extension Int {
    
    func secondsToFormattedTimeString() -> String {
        let minutes = (self / 60) % 60
        let seconds = self % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}

extension Date {
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? Date()
    }
    
//    var noon: Date {
//        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self) ?? Date()
//    }
}

extension UIColor {
    
    static var firstColor: UIColor {
        return UIColor(red: 180/255.0, green: 0, blue: 0, alpha: 1)
    }
    
    static var secondColor: UIColor {
        return UIColor.white
    }
    
    static var thirdColor: UIColor {
        return UIColor(white: 0.3, alpha: 1)
    }
    
    static var fourthColor: UIColor {
        return UIColor(white: 0.6, alpha: 1)
    }
}

