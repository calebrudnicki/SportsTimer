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
    
    
//MARK: Variables
    
    var count: String!
    var score1 = 0
    var score2 = 0
    var winnerText: String!
    var scoreText: String!
    

//MARK: Boilerplate Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PhoneSession.sharedInstance.startSession()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScoreboardViewController.receivedGivePhoneScoreDataNotification(_:)), name:"givePhoneScoreData", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func receivedGivePhoneScoreDataNotification(notification: NSNotification) {
        print("Made it here")
    }
    
    
////MARK: Session
//
//    //This function connects with the watch to read data and use it on the phone. The session runs on a background thread which does not work well if you want to update UI elements. It then calls the timesUp() method with the timer from the watch is at 0
//    func session(session: WCSession, didReceiveMessage gameStats: [String : AnyObject]) {
//        if let gameStatsScores = gameStats["Scores"] as? [Int] {
//            count = self.convertSeconds(gameStatsScores[0])
//            score1 = gameStatsScores[1]
//            score2 = gameStatsScores[2]
//            //This method allows you to jump from the background thread that the session is in to the main thread to update the UI
//            dispatch_async(dispatch_get_main_queue()) {
//                self.timerLabel.text = self.count
//                self.player1Score.text = String(self.score1)
//                self.player2Score.text = String(self.score2)
//            }
//        }
//        if Int(count) == 0 {
//            timesUp()
//        }
//    }
    
    
//MARK: Timer Functions
    
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
    }
    
    //This function converts seconds into the string format minutes:seconds
    func convertSeconds(seconds: Int) -> String {
        let secs: Double! = Double(seconds)
        let minutePlace = Int(floor(secs / 60) % 60)
        let secondPlace = Int(floor(secs) % 60)
        return String(format: "%02d:%02d", minutePlace, secondPlace)
    }

}