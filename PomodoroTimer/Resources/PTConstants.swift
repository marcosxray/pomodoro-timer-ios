//
//  Constants.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

struct PTConstants {
    
    static let initialTaskTime = 5 // * 60
    static let initialRestTime = 2 // * 60
    static let initialLongRestTime = 2 // * 60
    static let pomodoroRounds = 4
    
    static let NOTIFICATION_KEY = "NewPomodoroNotification"
    
    struct NibNames {
        static let sectionHeader = "PTSectionHeaderView"
    }
    
    struct Titles {
        static let home = "Pomodoro"
        static let history = "History"
        static let today = "TODAY"
        static let yesterday = "YESTERDAY"
    }
}
