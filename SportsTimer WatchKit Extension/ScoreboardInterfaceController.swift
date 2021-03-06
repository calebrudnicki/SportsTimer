//
//  InterfaceController.swift
//  SportsTimer WatchKit Extension
//
//  Created by Caleb Rudnicki on 6/23/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ScoreboardInterfaceController: WKInterfaceController, WCSessionDelegate {
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(error)
    }

    
//MARK: Outlets
    
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var player1Score: WKInterfaceButton!
    @IBOutlet var player2Score: WKInterfaceButton!
    
    
//MARK: Variables
    
    var countdown: TimeInterval = 600
    var backingTimer: Timer?
    var score1 = 0
    var score2 = 0
    
    
//MARK: Boilerplate Functions
    
    //This functions calls sets the labels to their preset values and sets the class as an observer of the checkWatchTimer notification
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.newGame()
        player1Score.setTitle(String(score1))
        player2Score.setTitle(String(score2))
    }
    
    //This function creates a new game and a shared instance of a session
    override func willActivate() {
        super.willActivate()
        WatchSession.sharedInstance.startSession()
    }
    
    //This function invalidates the backing timer when the end game button is tapped
    override func didDeactivate() {
        super.didDeactivate()
        backingTimer?.invalidate()
    }
    
    //This function calls a shared instance of tellPhoneToStopGame() when the end game button is tapped
    override func willDisappear() {
        WatchSession.sharedInstance.tellPhoneToStopGame()
    }
    
    //This functions sets the back button's text
    override init () {
        super.init ()
        self.setTitle("End Game")
    }


//MARK: Starting a New Game
    
    //This function that is called when the start game button is chosen
    func newGame() {
        let date = Date(timeIntervalSinceNow: countdown)
        timer.setDate(date)
        timer.start()
        WatchSession.sharedInstance.tellPhoneToStartGame(countdown)
        //This is a one second timer that calls the secondTimerFired() function everytime it ends, then it repeats
        backingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ScoreboardInterfaceController.secondTimerFired), userInfo: nil, repeats: true)
    }
    
    
//MARK: Timer Functions
    
    //This function subtracts from the countdown variable every second when it is called and then calls the timesUp() function when countdown is less than 0
    func secondTimerFired() {
        countdown -= 1
        if countdown < 0 {
            self.timesUp()
        }
    }
    
    //This function that runs when the countdown variable is less than 0 first disables the backingTimer, then it notifies the user that the game is over while also displaying the result of the game and disabling the buttons
    func timesUp() {
        backingTimer?.invalidate()
        WKInterfaceDevice().play(.failure)
        if score1 > score2 {
            player1Score.setTitle("W")
            player1Score.setBackgroundColor(UIColor.green)
            player2Score.setTitle("L")
            player2Score.setBackgroundColor(UIColor.red)
        } else if score2 > score1 {
            player2Score.setTitle("W")
            player2Score.setBackgroundColor(UIColor.green)
            player1Score.setTitle("L")
            player1Score.setBackgroundColor(UIColor.red)
        } else {
            player1Score.setTitle("T")
            player1Score.setBackgroundColor(UIColor.blue)
            player2Score.setTitle("T")
            player2Score.setBackgroundColor(UIColor.blue)
        }
        player1Score.setEnabled(false)
        player2Score.setEnabled(false)
    }
    
    
//MARK: Actions
    
    //This function adds a goal to Player 1's score and sends that info to the phone
    @IBAction func goalButton1() {
        score1 = score1 + 1
        player1Score.setTitle(String(score1))
        WatchSession.sharedInstance.tellPhoneScoreData(score1, score2: score2)
    }
    
    //This functions adds a goal to Player 2's score and sends that info to the phone
    @IBAction func goalButton2() {
        score2 = score2 + 1
        player2Score.setTitle(String(score2))
        WatchSession.sharedInstance.tellPhoneScoreData(score1, score2: score2)
    }
    
    //This function pauses the timer when the pause button is tapped
    @IBAction func pauseButtonTapped() {
        timer.stop()
    }
    
    //This function starts the timer when the play button is tapped
    @IBAction func startButtonTapped() {
        countdown -= 1
        self.newGame()
    }
    
}
