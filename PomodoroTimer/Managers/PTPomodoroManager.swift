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
        
        _timerStatus.asObservable().subscribe(onNext: { [unowned self] value in
            self.timerStatus.onNext(value)
        }).disposed(by: disposeBag)
        
        timer.currentTime.asObserver().subscribe(onNext: { [unowned self] value in
            
            guard value == 0 else {
                var time: Int = 0
                
                switch self._timerStatus.value {
                case .task:
                    time = self.taskTime.value - value
                    self.runningTaskTime = value
                case .rest:
                    time = self.restTime.value - value
                case .longRest:
                    time = self.longRestTime.value - value
                case .none:
                    time = self.taskTime.value
                }
                
                self.currentTime.onNext(time)
                return
            }
            
        }).disposed(by: disposeBag)
        
        
        self.currentTime.asObserver().filter({ $0 == 0 }).subscribe(onNext: { [unowned self] _ in

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


        self._timerStatus.asObservable().observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [unowned self] state in

            if state != .none {
                    self.startTimer()
                    if state == .task { self.roundCounter.value += 1 }
            } else {
                    self.roundCounter.value = 0
                    self.currentTime.onNext(self.taskTime.value)
                    self.stopTimer()
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

