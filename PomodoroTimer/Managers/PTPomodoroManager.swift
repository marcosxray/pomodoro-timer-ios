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
    var currentTime = BehaviorSubject<Int>(value: PTConstants.initialTaskTime)
    var timerStatus = BehaviorSubject<TimerStatus>(value: .none)
    
    var taskTime = Variable<Int>(PTConstants.initialTaskTime)
    var restTime = Variable<Int>(PTConstants.initialRestTime)
    var longRestTime = Variable<Int>(PTConstants.initialLongRestTime)
    var roundCounter = Variable<Int>(0)
    var _timerStatus = Variable<TimerStatus>(.none)
    
    var disposeBag = DisposeBag()
    
    fileprivate var runningTaskTime: Int = 0
    
    // MARK: Private variables
    private let timer: PTTimer
    
    // MARK: - Initialization methods
    init(timer: PTTimer? = nil) {
        if let timer = timer {
            self.timer = timer
        } else {
            self.timer = PTTimer.shared
        }
        setupRx()
    }
    
    // MARK: - Private methods
    private func setupRx() {
        
        _timerStatus.asObservable().subscribe(onNext: { [weak self] value in
            self?.timerStatus.onNext(value)
        }).disposed(by: disposeBag)
        
        timer.currentTime.asObserver().subscribe(onNext: { [weak self] value in
            
            if let existingSelf = self {
                guard value == 0 else {
                    var time: Int = 0
                    
                    switch existingSelf._timerStatus.value {
                    case .task:
                        time = existingSelf.taskTime.value - value
                        existingSelf.runningTaskTime = value
                    case .rest:
                        time = existingSelf.restTime.value - value
                    case .longRest:
                        time = existingSelf.longRestTime.value - value
                    case .none:
                        time = existingSelf.taskTime.value
                    }
                    
                    existingSelf.currentTime.onNext(time)
                    return
                }
            }
        }).disposed(by: disposeBag)
        
        
        self.currentTime.asObserver().filter({ $0 == 0 }).subscribe(onNext: { [weak self] _ in

            if let existingSelf = self {
                
                switch existingSelf._timerStatus.value {
                case .task:
                    if existingSelf.roundCounter.value < PTConstants.pomodoroRounds {
                        existingSelf._timerStatus.value = .rest
                    } else {
                        existingSelf._timerStatus.value = .longRest
                        existingSelf.roundCounter.value = 0
                    }
                    
                    existingSelf.pomodoroDidFinish()
                    
                case .rest, .longRest:
                    existingSelf._timerStatus.value = .task
                    
                default:
                    existingSelf.roundCounter.value = 0
                }
            }

        }).disposed(by: disposeBag)


        self._timerStatus.asObservable().observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] state in

            if let existingSelf = self {
                if state != .none {
                    existingSelf.startTimer()
                    if state == .task { existingSelf.roundCounter.value += 1 }
                } else {
                    
                    existingSelf.roundCounter.value = 0
                    existingSelf.currentTime.onNext(existingSelf.taskTime.value)
                    existingSelf.stopTimer()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func startTimer() {
        timer.start()
    }
    
    private func stopTimer() {
        timer.stop()
        timer.reset()
    }
    
    private func pomodoroDidFinish() {
        let pomodoro = PTPomodoro(status: .finished, time: taskTime.value)
        propagateNewPomodoro(pomodoro: pomodoro)
    }
    
    private func propagateNewPomodoro(pomodoro: PTPomodoro) {
        PTStorage.addPomodoro(pomodoro: pomodoro)
        PTNotification.advertisePomodoro(pomodoro: pomodoro)
    }
    
    // MARK: - Internal methods
    func startPomodoro() {
        _timerStatus.value = .task
    }
    
    func stopPomodoro() {
        if _timerStatus.value == .task {
            let pomodoro = PTPomodoro(status: .stopped, time: runningTaskTime)
            propagateNewPomodoro(pomodoro: pomodoro)
        }
        
        _timerStatus.value = .none
    }
}

