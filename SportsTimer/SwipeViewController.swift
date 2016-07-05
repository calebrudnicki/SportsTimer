//
//  SwipeViewController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 6/23/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import AudioToolbox

class SwipeViewController: UIViewController {
    
//MARK: Outlets

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    
    
//MARK: Variables

    let leftSwipe = UISwipeGestureRecognizer()
    let rightSwipe = UISwipeGestureRecognizer()
    var timer: NSTimer = NSTimer()
    var count = 20
    var score1 = 0
    var score2 = 0
    
    
//MARK: viewDidLoad()
    
    //This function starts a new game and also sets all labels to their preset values
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
        timerLabel.text = String(count)
        player1Score.text = String(score1)
        player2Score.text = String(score2)
    }
    
    
//MARK: didReceiveMemoryWarning()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Starting a New Game
    
    //This function starts a new game by starting the timer and calling iniating the swipe functionality
    func newGame() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(SwipeViewController.updateTimer), userInfo: nil, repeats: true)
        initiateOrEndSwipes()
    }
    
    
//MARK: Timer Functions
    
    //This function updates the timerLabel so it always shows the correct time and checks to see if the times has run out
    func updateTimer() {
        count -= 1
        print(count)
        if count == -1 {
            timer.invalidate()
            timesUp()
        } else {
            timerLabel.text = String(count)
        }
        
    }
    
    //This function runs when the timer runs out. It disables the swipe functionality, plays a notification sound and displays the winner and loser to the user
    func timesUp() {
        initiateOrEndSwipes()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if score1 > score2 {
            player1Score.text = "W"
            player1Score.textColor = UIColor.greenColor()
            player2Score.text = "L"
            player2Score.textColor = UIColor.redColor()
        } else if score2 > score1 {
            player2Score.text = "W"
            player2Score.textColor = UIColor.greenColor()
            player1Score.text = "L"
            player1Score.textColor = UIColor.redColor()
        } else {
            player1Score.text = "T"
            player1Score.textColor = UIColor.blueColor()
            player2Score.text = "T"
            player2Score.textColor = UIColor.blueColor()
        }
    }
   
    
//MARK: Swipe Functions
    
    //This function handles each swipe and tells the program what to do after each swipe
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            score1 += 1
            player1Score.text = String(score1)
        }
        if sender.direction == .Left {
            score2 += 1
            player2Score.text = String(score2)
        }
    }
    
    //This function creates the swipe functionalty, yet if the timer is over, it will disable the swipe functionality
    func initiateOrEndSwipes() {
        leftSwipe.addTarget(self, action: #selector(SwipeViewController.handleSwipes(_:)))
        rightSwipe.addTarget(self, action: #selector(SwipeViewController.handleSwipes(_:)))
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        if count < 0 {
            leftSwipe.enabled = false
            rightSwipe.enabled = false
        }
    }
    
}
