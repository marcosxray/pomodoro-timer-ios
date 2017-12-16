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
    var taskTime = BehaviorSubject<Int>(value: 0)
    var restTime = BehaviorSubject<Int>(value: 0)
    var longRestTime = BehaviorSubject<Int>(value: 0)
    var taskCounter = BehaviorSubject<Int>(value: 0)
    var timerStatus = BehaviorSubject<TimerStatus>(value: .none)
    
    let taskOptions = [20 * 60,
                       25 * 60,
                       30 * 60,
                       35 * 60,
                       40 * 60,
                       45 * 60]
    
    let restOptions = [3 * 60,
                       4 * 60,
                       5 * 60]
    
    let longRestOptions = [15 * 60,
                           20 * 60,
                           25 * 60,
                           30 * 60]
    
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
        
        pomodoroManager.taskTime.asObservable().subscribe(onNext: { value in
            self.taskTime.onNext(value)
        }).disposed(by: disposeBag)
        
        pomodoroManager.restTime.asObservable().subscribe(onNext: { value in
            self.restTime.onNext(value)
        }).disposed(by: disposeBag)
        
        pomodoroManager.longRestTime.asObservable().subscribe(onNext: { value in
            self.longRestTime.onNext(value)
        }).disposed(by: disposeBag)
        
        pomodoroManager.taskCounter.asObservable().subscribe(onNext: { value in
            self.taskCounter.onNext(value)
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
    
    func updateTaskTime(taskTime:Int) {
        pomodoroManager.taskTime.value = taskTime
    }
    
    func updateRestTime(restTime: Int) {
        pomodoroManager.restTime.value = restTime
    }
    
    func updateLongRestTime(restTime: Int) {
        pomodoroManager.longRestTime.value = restTime
    }
}

