//
//  ScoreboardViewController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 7/6/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import AudioToolbox

class ScoreboardViewController: UIViewController {
    
//MARK: Outlets
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    
    
//MARK: Variables
    
    var timer: NSTimer!
    var totalTime: Int!
    var player1Score: Int! = 0
    var player2Score: Int! = 0
    var updatedWatchTimer: Int!
    var timerIsOn: Bool = false
    
    
//MARK: Boilerplate Functions
    
    //This function creates an instance of a shared session and establishes this class as an observer of the tellPhoneToStopGame, givePhoneScoreData, and tellPhoneToStartGame notifications
    override func viewDidLoad() {
        super.viewDidLoad()
        PhoneSession.sharedInstance.startSession()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScoreboardViewController.receivedTellPhoneToStopGameNotification(_:)), name:"tellPhoneToStopGame", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScoreboardViewController.receivedGivePhoneScoreDataNotification(_:)), name:"givePhoneScoreData", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScoreboardViewController.receivedTellPhoneToStartGameNotification(_:)), name:"tellPhoneToStartGame", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScoreboardViewController.receivedTellPhoneTheTimeNotification(_:)), name:"tellPhoneTheTime", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This function removes the observer when the view disappears
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
//MARK: Watch Communication Functions
    
    //This function that gets called everytime the tellPhoneToStopGame notification is posted resets all of the labels
    func receivedTellPhoneToStopGameNotification(notification: NSNotification) {
        timerIsOn = false
        timer.invalidate()
        timerLabel.text = "10:00"
        player1ScoreLabel.text = "0"
        player2ScoreLabel.text = "0"
        player1ScoreLabel.textColor = UIColor.whiteColor()
        player2ScoreLabel.textColor = UIColor.whiteColor()
    }
    
    func receivedTellPhoneTheTimeNotification(notification: NSNotification) {
        let dataDict = notification.object as? [String : AnyObject]
        self.updateWatchTimer(dataDict!)
    }
    
    //This function that gets called everytime a givePhoneScoreData notification is posted calls displayLabels()
    func receivedGivePhoneScoreDataNotification(notification: NSNotification) {
        let dataDict = notification.object as? [String : AnyObject]
        self.displayLabels(dataDict!)
    }
    
    //This function that gets called everytime a tellPhoneToStartGame notification is posted calls startTimer()
    func receivedTellPhoneToStartGameNotification(notification: NSNotification) {
        let dataDict = notification.object as? [String : AnyObject]
        self.startTimer(dataDict!)
    }
    
    
//MARK: Label Functions
    
    //This functions updates the score labels to match the watch's data
    func displayLabels(dataDict: [String : AnyObject]) {
        player1ScoreLabel.text = String(dataDict["Score1"]!)
        player2ScoreLabel.text = String(dataDict["Score2"]!)
        player1Score = Int(String(dataDict["Score1"]!))
        player2Score = Int(String(dataDict["Score2"]!))
    }
    
    //This functions runs once per second until the totalTime variable reaches 0 before it calls timesUp() with the winning player as a parameter
    func eachSecond(timer: NSTimer) {
        if totalTime >= 0 {
            timerLabel.text = self.convertSeconds(totalTime)
        } else {
            timer.invalidate()
        }
        if totalTime == 0 {
            if self.player1Score > self.player2Score {
                self.timesUp("Player1")
            } else if self.player2Score > self.player1Score {
                self.timesUp("Player2")
            } else {
                self.timesUp("Tie")
            }
        }
        totalTime = totalTime - 1
    }
    
    func updateWatchTimer(dataDict: [String : AnyObject]) {
        updatedWatchTimer = Int(String(dataDict["Time"]!))
    }
    
    
//MARK: Timer Functions
    
    //This functions sets totalTime to the amount of starting time on the watch and then creates a timer that calls eachSecond()
    func startTimer(dataDict: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            if self.timerIsOn == false {
                self.totalTime = Int(String(dataDict["Time"]!))!
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ScoreboardViewController.eachSecond(_:)), userInfo: nil, repeats: true)
            }
            self.timerIsOn = true
        }
    }
    
    //This functions gets called when the time is up and determines which player is the winner
    func timesUp(winner: String) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if winner == "Player1" {
            player1ScoreLabel.textColor = UIColor.greenColor()
            player2ScoreLabel.textColor = UIColor.redColor()
        } else if winner == "Player2" {
            player2ScoreLabel.textColor = UIColor.greenColor()
            player1ScoreLabel.textColor = UIColor.redColor()
        } else if winner == "Tie" {
            player1ScoreLabel.textColor = UIColor.blueColor()
            player2ScoreLabel.textColor = UIColor.blueColor()
        }
    }
    
    //This function converts seconds into the string format minutes:seconds
    func convertSeconds(seconds: Int) -> String {
        let secs: Double! = Double(seconds)
        let minutePlace = Int(floor(secs / 60) % 60)
        let secondPlace = Int(floor(secs) % 60)
        return String(format: "%02d:%02d", minutePlace, secondPlace)
    }
    
}