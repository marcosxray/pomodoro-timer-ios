//
//  Extensions.swift
//  PomodoroTimer
//
//  Created by retina on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

extension Int {
    
    func secondsToFormattedTimeString() -> String {
        let minutes = (self / 60) % 60
        let seconds = self % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
