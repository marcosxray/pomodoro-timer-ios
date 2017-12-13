//
//  PomodoroManager.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation
import RxSwift

enum TimerStatus {
    case none
    case task
    case rest
    case longRest
}

class PTPomodoroManager {
    
    // MARK: - Internal variables
    var currentTime = BehaviorSubject<Int>(value: PTConstants.initialRoundTime)
    var timerStatus = BehaviorSubject<TimerStatus>(value: .none)
    
    var roundTime = Variable<Int>(PTConstants.initialRoundTime)
    var restTime = Variable<Int>(PTConstants.initialRestTime)
    var longRestTime = Variable<Int>(PTConstants.initialLongRestTime)
    var roundCounter = Variable<Int>(0)
    var _timerStatus = Variable<TimerStatus>(.none)
    
    var disposeBag = DisposeBag()
    
    // MARK: Private variables
    private let timer = PTTimer.shared
    
    // MARK: - Initialization methods
    init() {
        setupRx()
    }
    
    // MARK: - Private methods
    private func setupRx() {
        
        _timerStatus.asObservable().subscribe(onNext: { value in
            self.timerStatus.onNext(value)
        }).disposed(by: disposeBag)
        
        timer.currentTime.asObserver().subscribe(onNext: { value in
            
            guard value == 0 else {
                var time: Int = 0
                
                switch self._timerStatus.value {
                case .task:
                    time = self.roundTime.value - value
                case .rest:
                    time = self.restTime.value - value
                case .longRest:
                    time = self.longRestTime.value - value
                case .none:
                    time = self.roundTime.value
                }
                
                self.currentTime.onNext(time)
                return
            }
            
        }).disposed(by: disposeBag)
        
        
        self.currentTime.asObserver().filter({ $0 == 0 }).subscribe(onNext: { _ in

            switch self._timerStatus.value {
                
            case .task:
                if self.roundCounter.value < PTConstants.pomodoroRounds {
                    self._timerStatus.value = .rest
                } else {
                    self._timerStatus.value = .longRest
                    self.roundCounter.value = 0
                }
                
                self.pomodoroDidFinish()
                
            case .rest, .longRest:
                self._timerStatus.value = .task
                
            default:
                self.roundCounter.value = 0
            }
            
        }).disposed(by: disposeBag)
        
        
        self._timerStatus.asObservable().subscribe(onNext: { state in
            
            if state != .none {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.startTimer()
                    if state == .task { self.roundCounter.value += 1 }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.roundCounter.value = 0
                    self.currentTime.onNext(self.roundTime.value)
                    self.stopTimer()
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func pomodoroDidFinish() {
        PTNotification.fireNotification()
    }
    
    private func startTimer() {
        timer.start()
    }
    
    private func stopTimer() {
        timer.stop()
        timer.reset()
    }
    
    // MARK: - Internal methods
    func startPomodoro() {
        _timerStatus.value = .task
    }
    
    func stopPomodoro() {
        _timerStatus.value = .none
    }
}

