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
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    
    
//MARK: Variables

    let leftSwipe = UISwipeGestureRecognizer()
    let rightSwipe = UISwipeGestureRecognizer()
    var timer: NSTimer = NSTimer()
    var isPaused = false
    var count = 25
    var score1 = 0
    var score2 = 0
    var winnerText: String!
    var scoreText: String!
    var playImage:UIImage?
    
    
//MARK: Boilerplate Functions
    
    //This function starts a new game and also sets all labels to their preset values
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
        timerLabel.text = String(count)
        player1Score.text = String(score1)
        player2Score.text = String(score2)
    }
    
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
    
    //This function updates the timerLabel as long as the timer is not paused so it always shows the correct time and also checks to see if the times has run out
    func updateTimer() {
        if isPaused == false {
            count -= 1
            if count == -1 {
                timer.invalidate()
                timesUp()
            } else {
                timerLabel.text = String(count)
            }
        }
    }
    
    //This function plays a notification sound and sets all necessary game info to variables before calling the segue to the FinalViewController
    func timesUp() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if score1 > score2 {
            winnerText = "Player 1"
            scoreText = "\(score1) - \(score2)"
        } else if score2 > score1 {
            winnerText = "Player 2"
            scoreText = "\(score2) - \(score1)"
        } else {
            winnerText = "Tie Game"
            scoreText = "\(score1) - \(score2)"
        }
        self.performSegueWithIdentifier("endOfGameFromSwipeSegue", sender: self)
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
    
    //This function handles each swipe, telling the program what to do after each swipe and changing the label's colors momentarily
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            score1 += 1
            player1Score.text = String(score1)
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    self.player1Score.textColor = UIColor.greenColor()
                    self.view.alpha = 0.0
                }, completion: { finished in
                    self.player1Score.textColor = UIColor.whiteColor()
            })
            self.view.alpha = 1.0
        }
        if sender.direction == .Left {
            score2 += 1
            player2Score.text = String(score2)
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.player2Score.textColor = UIColor.greenColor()
                self.view.alpha = 0.0
                }, completion: { finished in
                    self.player2Score.textColor = UIColor.whiteColor()
            })
            self.view.alpha = 1.0
        }
    }
    
    
//MARK: Action Functions
    
    //This function uses an alert to double checks to see if the user really wants to delete the current game once the button is tapped. Also once this button is tapped, it pauses the clock
    @IBAction func exitButtonTapped(sender: AnyObject) {
        isPaused = true
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to end the game?", preferredStyle: .ActionSheet)
        let yesAction = UIAlertAction(title: "Yes, I want to exit", style: .Default) { (action) in
            self.performSegueWithIdentifier("exitSegue", sender: self)
        }
        let noAction = UIAlertAction(title: "No, resume playing", style: .Default) { (handler) in
            self.isPaused = false
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //This function pauses the timer when the pause button is pressed and changes the button's color
    @IBAction func pauseButtonPressed(sender: AnyObject) {
        if isPaused == false {
            isPaused = true
            leftSwipe.enabled = false
            rightSwipe.enabled = false
            pauseButton.tintColor = UIColor.redColor()
        } else {
            isPaused = false
            leftSwipe.enabled = true
            rightSwipe.enabled = true
            pauseButton.tintColor = UIColor.blackColor()
        }
    }
   
    
//MARK: Segues
    
    //This function holds the info needed when a segue is called from the SwipeViewController. It checks to see which segue is called (either the regular one or the unwind segue) and does the appropriate actions to make it work
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier != "exitSegue" {
                let finalViewController = segue.destinationViewController as! FinalViewController
                finalViewController.playerText = winnerText
                finalViewController.resultText = scoreText
            }
        }
    }
    
}