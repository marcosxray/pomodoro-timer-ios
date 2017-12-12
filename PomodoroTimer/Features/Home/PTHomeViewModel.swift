//
//  PTHomeViewModel.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation
import RxSwift

class PTHomeViewModel {
    
    // MARK: - Internal variables
    var currentTime = BehaviorSubject<Int>(value: 0)
    var roundTime = BehaviorSubject<Int>(value: 0)
    var restTime = BehaviorSubject<Int>(value: 0)
    var longRestTime = BehaviorSubject<Int>(value: 0)
    var roundCounter = BehaviorSubject<Int>(value: 0)
    var timerStatus = BehaviorSubject<TimerStatus>(value: .none)
    
    // MARK: - Private variables
    private let pomodoroManager = PTPomodoroManager()
    private var disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init() {
        setupRx()
    }
    
    // MARK: - Private methods
    private func setupRx() {
        pomodoroManager.currentTime.asObservable().subscribe(onNext: { value in
            self.currentTime.onNext(value)
        }).disposed(by: disposeBag)
        
        pomodoroManager.roundTime.asObservable().subscribe(onNext: { value in
            self.roundTime.onNext(value)
        }).disposed(by: disposeBag)
        
        pomodoroManager.restTime.asObservable().subscribe(onNext: { value in
            self.restTime.onNext(value)
        }).disposed(by: disposeBag)
        
        pomodoroManager.longRestTime.asObservable().subscribe(onNext: { value in
            self.longRestTime.onNext(value)
        }).disposed(by: disposeBag)
        
        pomodoroManager.roundCounter.asObservable().subscribe(onNext: { value in
            self.roundCounter.onNext(value)
        }).disposed(by: disposeBag)
        
        pomodoroManager.timerStatus.asObservable().subscribe(onNext: { state in
            self.timerStatus.onNext(state)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Internal methods
    func startTimer() {
        pomodoroManager.startPomodoro()
    }
    
    func stopTimer() {
        pomodoroManager.stopPomodoro()
    }
    
    func updateRoundTime(roundTime:Int) {
        pomodoroManager.roundTime.value = roundTime
    }
    
    func updateRestTime(restTime: Int) {
        pomodoroManager.restTime.value = restTime
    }
    
    func updateLongRestTime(restTime: Int) {
        pomodoroManager.longRestTime.value = restTime
    }
}

