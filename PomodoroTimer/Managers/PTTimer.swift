//
//  PTTimer.swift
//  PomodoroTimer
//
//  Created by Marcos Borges on 12/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import Foundation
import RxSwift

class PTTimer {
    
    // MARK: - Internal variables
    static let shared = PTTimer()
    var currentTime = BehaviorSubject<Int>(value: 0)
    
    // MARK: - Private variables
    private var timer = Timer()
    private var _currentTime = Variable<Int>(0)
    private var disposeBag = DisposeBag()
    
    // MARK: - Initialization methods
    private init() {
        _currentTime.asObservable().subscribe(onNext: { value in
            self.currentTime.onNext(value)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    @objc private func updateCurrentTime() {
        _currentTime.value += 1
    }
    
    // MARK - Internal methods
    func start() {
        stop()
        reset()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateCurrentTime()
        })
    }
    
    func stop() {
        self.timer.invalidate()
        self.timer = Timer()
    }
    
    func reset() {
        _currentTime.value = 0
    }
}
