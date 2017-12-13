//
//  PTStorage.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 13/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation

struct PTStorage {
    
    static func addPomodoro(pomodoro: PTPomodoro) {
        
        var allPomodoros = PTStorage.getAllPomodoros()
        allPomodoros.append(pomodoro)
        
        let defaults = UserDefaults.standard
        defaults.set(allPomodoros, forKey: "SavedPomodoros")
        defaults.synchronize()
    }
    
    static func getAllPomodoros() -> [PTPomodoro] {
        
        let defaults = UserDefaults.standard
        let pomodoros = defaults.object(forKey:"SavedPomodoros") as? [PTPomodoro] ?? [PTPomodoro]()
        return pomodoros
    }
}
