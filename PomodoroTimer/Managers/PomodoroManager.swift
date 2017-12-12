//
//  PomodoroManager.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation
import RxSwift

class PomodoroManager {
    
    // MARK: - Internal variables
    var currentTime = BehaviorSubject<Int>(value: 0)
    var disposeBag = DisposeBag()
    
    var numberOfRounds = Variable<Int>(Constants.initialNumberOfRounds)
    var roundTime = Variable<Int>(Constants.initialRoundTime)
    var restTime = Variable<Int>(Constants.initialRestTime)
    
    // MARK: Private variables
    private let timer = PTTimer.shared
    
    // MARK: - Initialization methods
    init() {
        setupRx()
    }
    
    // MARK: - Private methods
    private func setupRx() {
        timer.currentTime.asObserver().subscribe(onNext: { value in
            self.currentTime.onNext(value)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Internal methods
    func startTimer() {
        timer.start()
    }
    
    func stopTimer() {
        timer.stop()
    }
    
    func resetTimer() {
        timer.reset()
    }
}

