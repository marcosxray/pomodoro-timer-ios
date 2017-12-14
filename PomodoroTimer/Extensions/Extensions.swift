//
//  Extensions.swift
//  PomodoroTimer
//
//  Created by retina on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation

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
        formatter.dateFormat = "hh:mm a" // "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter.string(from: self)
    }
}
