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
    
    var currentTime: Observable<Int> {
        return _currentTime.asObservable()
    }
    
    // MARK: - Private variables
    private var timer = Timer()
    private var _currentTime = Variable<Int>(0)
    private var disposeBag = DisposeBag()
    
    // MARK: - Private methods
    @objc private func updateCurrentTime() {
        _currentTime.value += 1
    }
    
    func start() {
        stop()
        reset()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCurrentTime), userInfo: nil, repeats: true)
    }
    
    func stop() {
        self.timer.invalidate()
        self.timer = Timer()
    }
    
    func reset() {
        _currentTime.value = 0
    }
}

