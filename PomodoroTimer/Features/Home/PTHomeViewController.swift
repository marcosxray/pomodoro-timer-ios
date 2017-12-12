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
            self.timerLabel.text = "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.roundTime.asObserver().bind(onNext: { value in
            self.roundTimeLabel.text = "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.restTime.asObserver().bind(onNext: { value in
            self.restTimeLabel.text = "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.longRestTime.asObserver().bind(onNext: { value in
            self.longRestTimeLabel.text = "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.roundCounter.asObserver().bind(onNext: { value in
            self.roundCounterLabel.text = "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.timerStatus.asObservable().bind(onNext: { status in
            if status == .none {
                self.changePlayStopButton(playing: false)
            } else {
                self.changePlayStopButton(playing: true)
            }
        }).disposed(by: disposeBag)
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
