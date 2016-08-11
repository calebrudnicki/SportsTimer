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

    
//MARK: Boilerplate Functions
    
    //This function creates an instance of a shared session and establishes this class as an observer of the tellPhoneToStopGameand givePhoneAllData notifications
    override func viewDidLoad() {
        super.viewDidLoad()
        PhoneSession.sharedInstance.startSession()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScoreboardViewController.receivedTellPhoneToStopGameNotification(_:)), name:"tellPhoneToStopGame", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScoreboardViewController.receivedGivePhoneAllDataNotification(_:)), name:"givePhoneAllData", object: nil)
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
        timerLabel.text = "10:00"
        player1ScoreLabel.text = "0"
        player2ScoreLabel.text = "0"
        player1ScoreLabel.textColor = UIColor.whiteColor()
        player2ScoreLabel.textColor = UIColor.whiteColor()
    }

    //This function that gets called everytime the givePhoneAllData notification is posted calls displayLabels()
    func receivedGivePhoneAllDataNotification(notification: NSNotification) {
        let dataDict = notification.object as? [String : AnyObject]
        self.displayLabels(dataDict!)
    }
    
    
//MARK: Label Functions

    //This function changes the labels to the most up to date data before it checks to see whether or not the time has run out
    func displayLabels(dataDict: [String : AnyObject]) {
        let time = Int(String(dataDict["Time"]!))
        timerLabel.text = self.convertSeconds(time!)
        player1ScoreLabel.text = String(dataDict["Score1"]!)
        player2ScoreLabel.text = String(dataDict["Score2"]!)
        if time == 0 {
            if Int(String(dataDict["Score1"]!)) > Int(String(dataDict["Score2"]!)) {
                self.timesUp("Player1")
            } else if Int(String(dataDict["Score2"]!)) > Int(String(dataDict["Score1"]!)) {
                self.timesUp("Player2")
            } else {
                self.timesUp("Tie")
            }
        }
    }
    

//MARK: Timer Functions
    
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
        return String(format: "%2d:%02d", minutePlace, secondPlace)
    }

}