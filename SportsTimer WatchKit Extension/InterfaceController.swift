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

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
//MARK: Outlets

    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var player1Score: WKInterfaceButton!
    @IBOutlet var player2Score: WKInterfaceButton!
    
    
//MARK: Variables
    
    var countdown: NSTimeInterval = 20
    var backingTimer: NSTimer?
    var score1 = 0
    var score2 = 0
    var session: WCSession!
   
    
//MARK: Setting Default Values and Starting a New Game

    //This functions calls for a new game and also sets the labels to their preset values
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        newGame()
        player1Score.setTitle(String(score1))
        player2Score.setTitle(String(score2))
    }
   
    
//MARK: Activating and Deactivating

    //This function creates and starts a session as long as it is supported
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
//MARK: Starting a New Game
    
    //This function that is called when the start game button is chosen
    @IBAction func newGame() {
        let date = NSDate(timeIntervalSinceNow: countdown)
        timer.setDate(date)
        timer.start()
        //This is a one second timer that calls the secondTimerFired() function everytime it ends, then it repeats
        backingTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(InterfaceController.secondTimerFired), userInfo: nil, repeats: true)
    }
    
    
//MARK: Timer Functions
    
    //This function subtracts from the countdown variable every second when it is called and then calls the timesUp() function when countdown is less than 0
    func secondTimerFired() {
        self.sendMessageToPhone()
        countdown -= 1
        if countdown < 0 {
            self.timesUp()
        }
    }
    
    //This function that runs when the countdown variable is less than 0 first disables the backingTimer, then it notifies the user that the game is over while also displaying the result of the game and disabling the buttons
    func timesUp() {
        backingTimer?.invalidate()
        WKInterfaceDevice().playHaptic(.Failure)
        if score1 > score2 {
            player1Score.setTitle("W")
            player1Score.setBackgroundColor(UIColor.greenColor())
            player2Score.setTitle("L")
            player2Score.setBackgroundColor(UIColor.redColor())
        } else if score2 > score1 {
            player2Score.setTitle("W")
            player2Score.setBackgroundColor(UIColor.greenColor())
            player1Score.setTitle("L")
            player1Score.setBackgroundColor(UIColor.redColor())
        } else {
            player1Score.setTitle("T")
            player1Score.setBackgroundColor(UIColor.blueColor())
            player2Score.setTitle("T")
            player2Score.setBackgroundColor(UIColor.blueColor())
        }
        player1Score.setEnabled(false)
        player2Score.setEnabled(false)
    }
   
    
//MARK: Button Handlers
    
    //This function adds a goal to Player 1's score and sends that info to the phone
    @IBAction func goalButton1() {
        score1 = score1 + 1
        player1Score.setTitle(String(score1))
    }
    
    //This functions adds a goal to Player 2's score and sends that info to the phone
    @IBAction func goalButton2() {
        score2 = score2 + 1
        player2Score.setTitle(String(score2))
    }
    
    
//MARK: Talking to Phone
    
    //This function sends the time left in the game and each score over to the phone
    func sendMessageToPhone() {
        let gameStats = ["Scores": [countdown, score1, score2]]
        session.sendMessage(gameStats, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
}