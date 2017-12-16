//
//  PTHistoryViewModel.swift
//  PomodoroTimer
//
//  Created by retina on 13/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation
import RxSwift

class PTHistoryViewModel {
    
    // MARK: - Internal variables
    var dataSource = Variable<[[PTPomodoro]]>([])
    var dataSourceKeys: [String] = []
    
    // MARK: Initialization
    init() {
        self.updateData()
        PTNotification.registerForPomodoroNewNotification(object: self, using: { [unowned self] notification in
            self.updateData()
        })
    }
    
    // MARK: - Deinitializer
    deinit {
        PTNotification.unregisterForNewPomodoroNotification(object: self)
    }
    
    // MARK: - Private methods
    private func updateData() {
        
        let allPomodoros = PTStorage.getAllPomodoros()
        
        var groups:[String: [PTPomodoro]] = [:]
        for pomodoro in allPomodoros {
            
            let key = pomodoro.date.formattedDate()
            
            if let _ = groups[key] {
                groups[key]?.append(pomodoro)
            } else {
                let group = [pomodoro]
                groups[key] = group
            }
        }
        
        var keysArray = groups.keys.map({ return $0 })
        keysArray = keysArray.sorted(by: { $0 > $1 })
        
        var orderedPomodorosGroups: [[PTPomodoro]] = []
        for key in keysArray {
            if let pomodoros = groups[key] {
                orderedPomodorosGroups.append(pomodoros)
            }
        }

        self.dataSourceKeys = keysArray
        self.dataSource.value = orderedPomodorosGroups
    }
}
