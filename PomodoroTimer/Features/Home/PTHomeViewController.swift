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
    
    @IBOutlet weak var playStopButton: PTButton!
    @IBOutlet weak var roundTimeButton: UIButton!
    @IBOutlet weak var restTimeButton: UIButton!
    @IBOutlet weak var longRestTimeButton: UIButton!
    
    @IBOutlet weak var taskDisplay: UIView!
    @IBOutlet weak var restDisplay: UIView!
    @IBOutlet weak var longRestDisplay: UIView!
    @IBOutlet weak var roundDisplay: UIView!
    @IBOutlet weak var configButtonsDisplay: UIView!
    
    // MARK: - Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = PTConstants.Titles.home
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
    
    @IBAction func taskButtonDidTouch(_ sender: UIButton) {
        let alert = UIAlertController(title: "Task Time", message: "Please Choose an Option", preferredStyle: .actionSheet)
        
        for value in viewModel.taskOptions {
            alert.addAction(UIAlertAction(title: value.secondsToFormattedTimeString(), style: .default, handler: { (action) in
                self.viewModel.updateRoundTime(roundTime: value)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func restButtonDidTouch(_ sender: UIButton) {
        let alert = UIAlertController(title: "Rest Time", message: "Please Choose an Option", preferredStyle: .actionSheet)
        
        for value in viewModel.restOptions {
            alert.addAction(UIAlertAction(title: value.secondsToFormattedTimeString(), style: .default, handler: { (action) in
                self.viewModel.updateRestTime(restTime: value)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func longRestButtonDidTouch(_ sender: UIButton) {
        let alert = UIAlertController(title: "Long Rest Time", message: "Please Choose an Option", preferredStyle: .actionSheet)
        
        for value in viewModel.longRestOptions {
            alert.addAction(UIAlertAction(title: value.secondsToFormattedTimeString(), style: .default, handler: { (action) in
                self.viewModel.updateLongRestTime(restTime: value)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
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
                self.updateDisplays()
                self.changePlayStopButton(playing: false)
                self.configButtonsDisplay.isUserInteractionEnabled = true
                self.configButtonsDisplay.alpha = 1
            case .task:
                self.updateDisplays()
                self.changePlayStopButton(playing: true)
                self.taskDisplay.isUserInteractionEnabled = true
                self.taskDisplay.alpha = 1
            case .rest:
                self.updateDisplays()
                self.changePlayStopButton(playing: true)
                self.restDisplay.isUserInteractionEnabled = true
                self.restDisplay.alpha = 1
            case .longRest:
                self.updateDisplays()
                self.changePlayStopButton(playing: true)
                self.longRestDisplay.isUserInteractionEnabled = true
                self.longRestDisplay.alpha = 1
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateDisplays() {
        taskDisplay.alpha = 0
        restDisplay.alpha = 0
        longRestDisplay.alpha = 0
        configButtonsDisplay.alpha = 0.3
        
        taskDisplay.isUserInteractionEnabled = false
        restDisplay.isUserInteractionEnabled = false
        longRestDisplay.isUserInteractionEnabled = false
        configButtonsDisplay.isUserInteractionEnabled = false
    }
    
    private func changePlayStopButton(playing: Bool) {
        if playing {
            playStopButton.setTitle("STOP", for: .normal)
            playStopButton.borderWidth = 2
            playStopButton.borderColor = UIColor.secondColor
            playStopButton.setTitleColor(UIColor.secondColor, for: .normal)
            playStopButton.backgroundColor = UIColor.clear
            
            playStopButton.removeTarget(self, action: #selector(PTHomeViewController.startDidTouch), for: .touchUpInside)
            playStopButton.addTarget(self, action: #selector(PTHomeViewController.stopDidTouch), for: .touchUpInside)
            
        } else {
            playStopButton.setTitle("PLAY", for: .normal)
            playStopButton.borderWidth = 0
            playStopButton.borderColor = UIColor.clear
            playStopButton.setTitleColor(UIColor.firstColor, for: .normal)
            playStopButton.backgroundColor = UIColor.secondColor
            
            playStopButton.removeTarget(self, action: #selector(PTHomeViewController.stopDidTouch), for: .touchUpInside)
            playStopButton.addTarget(self, action: #selector(PTHomeViewController.startDidTouch), for: .touchUpInside)
        }
    }
}
