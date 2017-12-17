//
//  PTNotification.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 13/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - Aliases
let newPomodoroNotification = NSNotification.Name(rawValue: PTConstants.NOTIFICATION_KEY)

struct PTNotification {
    
    // MARK: - Internal methods
    static func advertisePomodoro(pomodoro: PTPomodoro) {
        NotificationCenter.default.post(Notification(name: newPomodoroNotification))
        PTNotification.playSound()
        PTNotification.fireLocalNotification()
    }
    
    static func registerForPomodoroNewNotification(object: AnyObject, using: @escaping (Notification) -> Void ) {
        NotificationCenter.default.addObserver(forName: newPomodoroNotification, object: nil, queue: OperationQueue.main, using: using)
    }
    
    static func unregisterForNewPomodoroNotification(object: AnyObject) {
        NotificationCenter.default.removeObserver(object)
    }
    
    static func fireLocalNotification() {
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: 0.5)
        notification.alertBody = "You've finished a pomodoro. Well done!"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    static func playSound() {
        let systemSoundID: SystemSoundID = 1016
        AudioServicesPlaySystemSound (systemSoundID)
    }
}
