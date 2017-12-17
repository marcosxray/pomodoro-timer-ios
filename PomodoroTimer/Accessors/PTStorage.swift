//
//  PTStorage.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 13/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation

struct PTStorage {
    
    // MARK: - Internal methods
    static func addPomodoro(pomodoro: PTPomodoro) {
        
        var allPomodoros = PTStorage.getAllPomodoros()
        allPomodoros.insert(pomodoro, at: 0)
        
        let defaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: allPomodoros)
        defaults.set(encodedData, forKey: "SavedPomodoros")
        defaults.synchronize()
    }
    
    static func getAllPomodoros() -> [PTPomodoro] {
        
        let defaults = UserDefaults.standard
        
        guard let decoded = defaults.object(forKey: "SavedPomodoros") as? Data else {
            return [PTPomodoro]()
        }
        
        let decodedPomodoros = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [PTPomodoro] ?? [PTPomodoro]()
        return decodedPomodoros
    }
}
