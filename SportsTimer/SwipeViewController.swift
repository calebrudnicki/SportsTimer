//
//  SwipeViewController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 6/23/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController {

    //The timer that the user can see
    @IBOutlet weak var timerLabel: UILabel!
    //A variable to keep track of the time in the background
    var count = 20
    //A NSTimer variable
    var timer: NSTimer = NSTimer()
    //Label for Player 1's score
    @IBOutlet weak var player1Score: UILabel!
    //Variable for Player 1's score
    var score1 = 0
    //Label for Player 2's score
    @IBOutlet weak var player2Score: UILabel!
    //Variable for Player 2's score
    var score2 = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Setting the original text of the timerLabel
        timerLabel.text = String(count)
        
        //Setting the original text for each of the player's scores
        player1Score.text = String(score1)
        player2Score.text = String(score2)
        
        //Making the timer count down from the preset number
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(SwipeViewController.UpdateTimer), userInfo: nil, repeats: true)
        
        //Naming variables for both the left and right swipe gestures
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SwipeViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SwipeViewController.handleSwipes(_:)))
        
        //Setting the direction for the leftwipe and rightSwipe variables
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        //Add the left and right swiping gestures to the view
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    //This function handles each swipe and tells the program what to do after each swipe
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        
        //For a left swipe
        if sender.direction == .Left {
            score1 += 1
            player1Score.text = String(score1)
        }
        
        //For a right swipe
        if sender.direction == .Right {
            score2 += 1
            player2Score.text = String(score2)
        }
        
    }
    
    //This function updates the timerLabel so it always shows the correct time
    func UpdateTimer() {
        
        count -= 1
        timerLabel.text = String(count)
        
    }
}
