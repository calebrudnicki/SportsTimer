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
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    

//MARK: Boilerplate Functions
    
    //This function creates an instance of a shared session and establishes this class as an observer of the givePhoneScoreData notification
    override func viewDidLoad() {
        super.viewDidLoad()
        PhoneSession.sharedInstance.startSession()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScoreboardViewController.receivedGivePhoneScoreDataNotification(_:)), name:"givePhoneScoreData", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This function removes the observer when the view disappears
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
  

//MARK: Watch Communication Functions
    
    //This function that gets called everytime a givePhoneScoreData notification is posted calls displayLabels()
    func receivedGivePhoneScoreDataNotification(notification: NSNotification) {
        let dataDict = notification.object as? [String : AnyObject]
        self.displayLabels(dataDict!)
    }
    
    
//MARK: Label Functions
    
    //This functions updates all of the labels to match the watch's data
    func displayLabels(dataDict: [String : AnyObject]) {
        timerLabel.text = String(dataDict["Countdown"]!)
        player1Score.text = String(dataDict["Score1"]!)
        player2Score.text = String(dataDict["Score2"]!)
        if Int(dataDict["Countdown"]! as! NSNumber) == 0 {
            if Int(dataDict["Score1"]! as! NSNumber) > Int(dataDict["Score2"]! as! NSNumber) {
                self.timesUp("Player1")
            } else if Int(dataDict["Score2"]! as! NSNumber) > Int(dataDict["Score1"]! as! NSNumber) {
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
            player1Score.textColor = UIColor.greenColor()
            player2Score.textColor = UIColor.redColor()
        } else if winner == "Player2" {
            player2Score.textColor = UIColor.greenColor()
            player1Score.textColor = UIColor.redColor()
        } else if winner == "Tie" {
            player1Score.textColor = UIColor.blueColor()
            player2Score.textColor = UIColor.blueColor()
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