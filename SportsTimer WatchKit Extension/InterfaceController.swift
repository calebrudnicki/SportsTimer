//
//  InterfaceController.swift
//  SportsTimer WatchKit Extension
//
//  Created by Caleb Rudnicki on 6/23/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet var timer: WKInterfaceTimer!                      //The timer that the user can see
    var backingTimer: NSTimer?                                  //The timer that triggers the ending sound
    @IBOutlet var player1Score: WKInterfaceButton!              //Player 1's score displayed to the user
    @IBOutlet var player2Score: WKInterfaceButton!              //Player 2's score displayed to the user
    var score1 = 0                                              //Variable to keep track of Player 1's score
    var score2 = 0                                              //Variable to keep track of Player 2's score
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        newGame()
        player1Score.setTitle(String(score1))
        player2Score.setTitle(String(score2))
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func newGame() {
        //This code starts the timer that the user can see
        let countdown: NSTimeInterval = 20
        let date = NSDate(timeIntervalSinceNow: countdown)
        timer.setDate(date)
        timer.start()
        
        //This code mimics the visual timer with a backing timer and calls the timesUp method when it hits 0
        backingTimer = NSTimer.scheduledTimerWithTimeInterval(countdown, target: self, selector: #selector(InterfaceController.timesUp), userInfo: nil, repeats: false)
    }
    
    //This function runs when the timer runs out. First it notifies the user that the game is over then it display the result and disables the buttons
    func timesUp() {
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
    
    //This function adds a goal to Player 1's score
    @IBAction func goalButton1() {
        score1 = score1 + 1
        player1Score.setTitle(String(score1))
    }
    
    //This functions adds a goal to Player 2's score
    @IBAction func goalButton2() {
        score2 = score2 + 1
        player2Score.setTitle(String(score2))
    }
}
