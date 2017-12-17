//
//  PTPomodoroManagerTests.swift
//  PomodoroTimerTests
//
//  Created by Marcos Borges on 17/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import XCTest
import RxSwift
@testable import PomodoroTimer

let kTaskTime = 8
let kRestTime = 3
let kLongRestTime = 5

class PTPomodoroManagerTests: XCTestCase {
    
    var manager: PTPomodoroManager = PTPomodoroManager(timer: TimerMock())
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        manager = PTPomodoroManager(timer: TimerMock())
        
        manager.taskTime.value = kTaskTime
        manager.restTime.value = kRestTime
        manager.longRestTime.value = kLongRestTime
    }
    
//    override func tearDown() {
//        super.tearDown()
//        disposeBag = DisposeBag()
//    }
    
    func testTaskCountDown() {
        
        let expectation: XCTestExpectation = self.expectation(description: "Pomodoro task time test.")
        
        var counter = 0
        
        manager.currentTime.asObservable().subscribe(onNext: { _ in
            if self.manager._timerStatus.value == .task {
                counter += 1
            }
        }).disposed(by: disposeBag)
        
        manager.timerStatus.asObservable().subscribe(onNext: { timerStatus in
            if timerStatus == .rest {
                XCTAssertEqual(counter, kTaskTime)
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        manager.startPomodoro()
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRestCountDown() {
        
        let expectation: XCTestExpectation = self.expectation(description: "Pomodoro rest time test.")
        
        var counter = 0
        
        manager.currentTime.asObservable().subscribe(onNext: { _ in
            if self.manager._timerStatus.value == .rest {
                counter += 1
            }
        }).disposed(by: disposeBag)
        
        manager.roundCounter.asObservable().subscribe(onNext: { value in
            if value == 2 {
                XCTAssertEqual(counter, kRestTime)
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        manager.startPomodoro()
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLongRestCountDown() {
        
        let expectation: XCTestExpectation = self.expectation(description: "Pomodoro long rest time test.")
        
        var counter = 0
        var didLongRest = false
        
        manager.currentTime.asObservable().subscribe(onNext: { value in
            if self.manager._timerStatus.value == .longRest {
                counter += 1
            }
        }).disposed(by: disposeBag)
        
        manager.timerStatus.asObservable().filter({ $0 == .longRest }).subscribe(onNext: { value in
            didLongRest = true
        }).disposed(by: disposeBag)
        
        manager.timerStatus.asObservable().filter({ $0 == .task }).subscribe(onNext: { value in
            if didLongRest {
                XCTAssertEqual(counter, kLongRestTime)
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        manager.startPomodoro()
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}

// MARK: - Mock class

class TimerMock: PTTimer {
    
    var counter: Int = 0
    var timer2 = Timer()
    
    override func setupRx() {}
    
    override func stop() {
        self.timer2.invalidate()
        self.timer2 = Timer()
    }

    override func start() {
        stop()
        reset()
        counter = 0
        self.timer2 = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        self.counter += 1
        self.currentTime.onNext(self.counter)
    }
}
