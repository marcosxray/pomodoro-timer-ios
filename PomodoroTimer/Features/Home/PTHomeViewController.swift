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
    
    // MARK: - Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    // MARK: - Internal methods
    @IBAction func startDidTouch(_ sender: UIButton) {
        viewModel.startTimer()
    }
    
    @IBAction func stopDidTouch(_ sender: UIButton) {
        viewModel.stopTimer()
    }
    
    // MARK: - Private methods
    private func setupRx() {
        viewModel.currentTime.asObservable().bind(onNext: { value in
            self.timerLabel.text = "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.roundTime.asObserver().bind(onNext: { value in
            //            let v = value / 60
            self.roundTimeLabel.text = "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.restTime.asObserver().bind(onNext: { value in
            //            let v = value / 60
            self.restTimeLabel.text = "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.longRestTime.asObserver().bind(onNext: { value in
            //            let v = value / 60
            self.longRestTimeLabel.text = "\(value)"
        }).disposed(by: disposeBag)
        
        viewModel.roundCounter.asObserver().bind(onNext: { value in
            self.roundCounterLabel.text = "\(value)"
        }).disposed(by: disposeBag)
    }
}
