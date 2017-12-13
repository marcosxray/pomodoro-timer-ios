//
//  PTNotification.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 13/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import UIKit
import AVFoundation

struct PTNotification {
    
    static func fireNotification() {
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: 5)
        notification.alertBody = "You've finished a pomodoro. Well done!"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
        PTNotification.playSound()
    }
    
    static func playSound() {
        let systemSoundID: SystemSoundID = 1016
        AudioServicesPlaySystemSound (systemSoundID)
    }
}
