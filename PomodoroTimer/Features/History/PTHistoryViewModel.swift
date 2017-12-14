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
    var dataSource = Variable<[PTPomodoro]>([])
    
    // MARK: Initialization
    init() {
        self.updateData()
        PTNotification.registerForPomodoroNewNotification(object: self, using: { notification in
            self.updateData()
        })
    }
    
    // MARK: - Deinitializer
    deinit {
        PTNotification.unregisterForNewPomodoroNotification(object: self)
    }
    
    // MARK: - Private methods
    private func updateData() {
        self.dataSource.value = PTStorage.getAllPomodoros()
    }
}
