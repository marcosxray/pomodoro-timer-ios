//
//  PTPomodoro.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation

enum PomodoroStatus {
//    case none
//    case running
    case stopped
    case finished
}

struct PTPomodoro {
    let status: PomodoroStatus
    let date: Date
    let time: Int
    
    init(status: PomodoroStatus, time: Int) {
        self.status = status
        self.time = time
        self.date = Date()
    }
}
