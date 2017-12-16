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
    @IBOutlet weak var roundCounterLabel: UILabel!
    
    @IBOutlet weak var playStopButton: UIButton!
    @IBOutlet weak var roundTimeButton: UIButton!
    @IBOutlet weak var restTimeButton: UIButton!
    @IBOutlet weak var longRestTimeButton: UIButton!
    
    @IBOutlet weak var taskDisplay: UIView!
    @IBOutlet weak var restDisplay: UIView!
    @IBOutlet weak var longRestDisplay: UIView!
    @IBOutlet weak var roundDisplay: UIView!
    
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
    private func setupRx() {
        viewModel.currentTime.asObservable().bind(onNext: { value in
            self.timerLabel.text = value.secondsToFormattedTimeString()
        }).disposed(by: disposeBag)

        viewModel.roundTime.asObserver().bind(onNext: { value in
            self.roundTimeButton.setTitle(value.secondsToFormattedTimeString(), for: .normal)
        }).disposed(by: disposeBag)
        
        viewModel.restTime.asObserver().bind(onNext: { value in
            self.restTimeButton.setTitle(value.secondsToFormattedTimeString(), for: .normal)
        }).disposed(by: disposeBag)
        
        viewModel.longRestTime.asObserver().bind(onNext: { value in
            self.longRestTimeButton.setTitle(value.secondsToFormattedTimeString(), for: .normal)
        }).disposed(by: disposeBag)
        
        viewModel.roundCounter.asObserver().bind(onNext: { value in
            self.roundCounterLabel.text = "\(value)"
            self.roundDisplay.isHidden = value > 0 ? false : true
        }).disposed(by: disposeBag)
        
        viewModel.timerStatus.asObservable().bind(onNext: { status in
            
            switch status {
            case .none:
                self.updateDisplayLabels()
                self.changePlayStopButton(playing: false)
            case .task:
                self.updateDisplayLabels()
                self.changePlayStopButton(playing: true)
                self.taskDisplay.isUserInteractionEnabled = true
                self.taskDisplay.alpha = 1
            case .rest:
                self.updateDisplayLabels()
                self.changePlayStopButton(playing: true)
                self.restDisplay.isUserInteractionEnabled = true
                self.restDisplay.alpha = 1
            case .longRest:
                self.updateDisplayLabels()
                self.changePlayStopButton(playing: true)
                self.longRestDisplay.isUserInteractionEnabled = true
                self.longRestDisplay.alpha = 1
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateDisplayLabels() {
        taskDisplay.alpha = 0.3
        restDisplay.alpha = 0.3
        longRestDisplay.alpha = 0.3
        
        taskDisplay.isUserInteractionEnabled = false
        restDisplay.isUserInteractionEnabled = false
        longRestDisplay.isUserInteractionEnabled = false
    }
    
    private func changePlayStopButton(playing: Bool) {
        if playing {
            playStopButton.setTitle("STOP", for: .normal)
            playStopButton.removeTarget(self, action: #selector(PTHomeViewController.startDidTouch), for: .touchUpInside)
            playStopButton.addTarget(self, action: #selector(PTHomeViewController.stopDidTouch), for: .touchUpInside)
            
        } else {
            playStopButton.setTitle("PLAY", for: .normal)
            playStopButton.removeTarget(self, action: #selector(PTHomeViewController.stopDidTouch), for: .touchUpInside)
            playStopButton.addTarget(self, action: #selector(PTHomeViewController.startDidTouch), for: .touchUpInside)
        }
    }
}
