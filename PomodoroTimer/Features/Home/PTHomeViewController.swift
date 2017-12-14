//
//  PTHomeViewController.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PTHomeViewController: UIViewController {
    
    // MARK: Internal variables
    
    // MARK: - Private variables
    private let viewModel = PTHomeViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - IBOutlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var roundTimeLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var longRestTimeLabel: UILabel!
    @IBOutlet weak var roundCounterLabel: UILabel!
    @IBOutlet weak var playStopButton: UIButton!
    
    @IBOutlet weak var taskDisplayLabel: UILabel!
    @IBOutlet weak var restDisplayLabel: UILabel!
    @IBOutlet weak var longRestDisplayLabel: UILabel!
    
    // MARK: - Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        changePlayStopButton(playing: false)
    }
    
    // MARK: - IBAction methods
    @IBAction private func startDidTouch() {
        viewModel.startTimer()
    }
    
    @IBAction private func stopDidTouch() {
        viewModel.stopTimer()
    }
    
    // MARK: - Private methods
    private func setupVisuals() {
        //
    }
    
    private func setupRx() {
        viewModel.currentTime.asObservable().bind(onNext: { value in
            self.timerLabel.text = value.secondsToFormattedTimeString() // "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.roundTime.asObserver().bind(onNext: { value in
            self.roundTimeLabel.text = value.secondsToFormattedTimeString() // "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.restTime.asObserver().bind(onNext: { value in
            self.restTimeLabel.text = value.secondsToFormattedTimeString() // "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.longRestTime.asObserver().bind(onNext: { value in
            self.longRestTimeLabel.text = value.secondsToFormattedTimeString() // "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.roundCounter.asObserver().bind(onNext: { value in
            self.roundCounterLabel.text = "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.timerStatus.asObservable().bind(onNext: { status in
            
            switch status {
            case .none:
                self.updateDisplayLabels()
                self.changePlayStopButton(playing: false)
            case .task:
                self.updateDisplayLabels()
                self.changePlayStopButton(playing: true)
                self.taskDisplayLabel.isUserInteractionEnabled = true
                self.taskDisplayLabel.alpha = 1
            case .rest:
                self.updateDisplayLabels()
                self.changePlayStopButton(playing: true)
                self.restDisplayLabel.isUserInteractionEnabled = true
                self.restDisplayLabel.alpha = 1
            case .longRest:
                self.updateDisplayLabels()
                self.changePlayStopButton(playing: true)
                self.longRestDisplayLabel.isUserInteractionEnabled = true
                self.longRestDisplayLabel.alpha = 1
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateDisplayLabels() {
        taskDisplayLabel.alpha = 0.3
        restDisplayLabel.alpha = 0.3
        longRestDisplayLabel.alpha = 0.3
        
        taskDisplayLabel.isUserInteractionEnabled = false
        restDisplayLabel.isUserInteractionEnabled = false
        longRestDisplayLabel.isUserInteractionEnabled = false
    }
    
    private func changePlayStopButton(playing: Bool) {
        if playing {
            playStopButton.setTitle("Stop", for: .normal)
            playStopButton.removeTarget(self, action: #selector(PTHomeViewController.startDidTouch), for: .touchUpInside)
            playStopButton.addTarget(self, action: #selector(PTHomeViewController.stopDidTouch), for: .touchUpInside)
            
        } else {
            playStopButton.setTitle("Play", for: .normal)
            playStopButton.removeTarget(self, action: #selector(PTHomeViewController.stopDidTouch), for: .touchUpInside)
            playStopButton.addTarget(self, action: #selector(PTHomeViewController.startDidTouch), for: .touchUpInside)
        }
    }
}
