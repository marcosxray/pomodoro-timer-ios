//
//  PomodoroManager.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation
import RxSwift

enum TimerState {
    case none
    case task
    case rest
    case longRest
}

class PTPomodoroManager {
    
    // MARK: - Internal variables
    var currentTime = BehaviorSubject<Int>(value: PTConstants.initialRoundTime)
    
    var roundTime = Variable<Int>(PTConstants.initialRoundTime)
    var restTime = Variable<Int>(PTConstants.initialRestTime)
    var longRestTime = Variable<Int>(PTConstants.initialLongRestTime)
    var roundCounter = Variable<Int>(0)
    var timerState = Variable<TimerState>(.none)
    
    var disposeBag = DisposeBag()
    
    // MARK: Private variables
    private let timer = PTTimer.shared
    
    // MARK: - Initialization methods
    init() {
        setupRx()
    }
    
    // MARK: - Private methods
    private func setupRx() {
        
        /////////-----------------------
        timer.currentTime.asObserver().subscribe(onNext: { value in
            
            var time: Int = 0
            
            switch self.timerState.value {
                
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
            
        }).disposed(by: disposeBag)
        
        
        
        /////////-----------------------
        self.timerState.asObservable().distinctUntilChanged().subscribe(onNext: { state in
            
            if state != .none {
                self.startTimer()
                print("start")
            } else {
                self.stopTimer()
                print("stop")
            }
            
        }).disposed(by: disposeBag)
        
        

        /////////-----------------------
        self.currentTime.asObserver().filter({ $0 == 0 }).subscribe(onNext: { value in
            
            switch self.timerState.value {

            case .task:

                if self.roundCounter.value < PTConstants.pomodoroRounds {
                    self.timerState.value = .rest
                } else {
                    self.timerState.value = .longRest
                    self.roundCounter.value = 0
                }

            case .none:
                self.roundCounter.value = 0

            default:
                self.timerState.value = .task
                print("")
            }
            
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Internal methods
    func startTimer() {
        timer.start()
        if timerState.value == .task { self.roundCounter.value += 1 }
    }
    
    func stopTimer() {
        timer.stop()
        timer.reset()
    }
}

