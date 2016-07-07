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
    var count = 5
    var score1 = 0
    var score2 = 0
    var finalIntro = "Congrats to"
    var finalWinner = ""
    var finalResult = "You won"
    var finalScore = ""
    
    
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
    
    //This function kicks off the timer and initiates the swipe functionality
    func newGame() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(SwipeViewController.updateTimer), userInfo: nil, repeats: true)
        activateSwipes()
    }
    
    
//MARK: Timer Functions
    
    //This function updates the timerLabel so it always shows the correct time and also checks to see if the times has run out
    func updateTimer() {
        count -= 1
        if count == -1 {
            timer.invalidate()
            timesUp()
        } else {
            timerLabel.text = String(count)
        }
        
    }
    
    //This function that runs when the timer runs out plays a notification sound and sets all necessary game info to variables before calling the segue to the FinalViewController
    func timesUp() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if score1 > score2 {
            finalWinner = "Player 1"
            finalScore = "\(score1) - \(score2)"
        } else if score2 > score1 {
            finalWinner = "Player 2"
            finalScore = "\(score2) - \(score1)"
        } else {
            finalIntro = "Good job to"
            finalWinner = "Both sides"
            finalResult = "You tied"
            finalScore = "\(score1) - \(score2)"
        }
        self.performSegueWithIdentifier("endOfGameSegue", sender: self)
    }
   
    
//MARK: Swipe Functions
    
    //This function creates the swipe functionalty
    func activateSwipes() {
        leftSwipe.addTarget(self, action: #selector(SwipeViewController.handleSwipes(_:)))
        rightSwipe.addTarget(self, action: #selector(SwipeViewController.handleSwipes(_:)))
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
    }
    
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
    
    
//MARK: Segues
    
    //This function holds the info needed when a segue is called from the SwipeViewController. It checks to see which segue is called (either the regular one or the unwind segue) and does the appropriate actions to make it work
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier != "Exit" {
                let finalViewController = segue.destinationViewController as! FinalViewController
                finalViewController.introText = finalIntro
                finalViewController.winnerText = finalWinner
                finalViewController.resultText = finalResult
                finalViewController.scoreText = finalScore
            }
        }
    }
    
}