//
//  PTPomodoro.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation

// MARK: - Definitions

enum PomodoroStatus: String {
    case stopped
    case finished
}

// MARK: - Class

class PTPomodoro: NSObject {
    
    // MARK: - Internal variables
    
    let status: PomodoroStatus
    let date: Date
    let time: Int
    
    // MARK: - Initialization
    
    init(status: PomodoroStatus, time: Int, date: Date? = nil) {
        self.status = status
        self.time = time
        self.date = date ?? Date()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let statusRaw = aDecoder.decodeObject(forKey: "status") as? String ?? ""
        let status = PomodoroStatus(rawValue: statusRaw) ?? .finished
        let date = aDecoder.decodeObject(forKey: "date") as? Date ?? Date()
        let time = aDecoder.decodeInteger(forKey: "time") as Int
        self.init(status: status, time: time, date: date)
    }
}

// MARK - Extensions

extension PTPomodoro: NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(status.rawValue, forKey: "status")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(time, forKey: "time")
    }
}

extension PTPomodoro {
    
    static func ==(lhs: PTPomodoro, rhs: PTPomodoro) -> Bool {
        return lhs.date.formattedDate() == rhs.date.formattedDate()
    }
    
    static func <(lhs: PTPomodoro, rhs: PTPomodoro) -> Bool {
        return lhs.date.formattedDate() < rhs.date.formattedDate()
    }
}

