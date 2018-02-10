# README #

Pomodoro Timer. An iOS app to let users do the Pomodoro technique (https://en.wikipedia.org/wiki/Pomodoro_Technique).

### Installation ###

This project uses Cocoapods as the dependency manager.
After downloading the source code, run the 'pod install' command in the project folder.

### Project considerations ###

* I believe that the interface is self-explanatory, in terms of functionality

* The app works on iPhones, running iOS 8 and later (including 4S)

* I used UserDefaults to save the list of executed pomodoros (I thought it would be overkill to use Core Data)

* I did some basic unit tests

* I did some basic interface tests. In order to run the interface test, the timeout constant must receive a value greater than the value of 'PTConstants.initialTaskTime', so that way a complete task count can be done (pomodoro.status = finished)

