//
//  PTHistoryCell.swift
//  PomodoroTimer
//
//  Created by retina on 13/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import UIKit

class PTHistoryCell: UITableViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "historyCell"
    
    // MARK: - Outlets
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Internal Methods
    func configureLayout(pomodoro: PTPomodoro) {

        timeLabel.text = pomodoro.time.secondsToFormattedTimeString()
        statusLabel.text = "\(pomodoro.status)"
        dateLabel.text = pomodoro.date.formattedTime()
    }
}
