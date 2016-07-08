//
//  ScoreboardViewController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 7/6/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import WatchConnectivity
import AudioToolbox

class ScoreboardViewController: UIViewController, WCSessionDelegate {

//MARK: Outlets
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    
    
//MARK: Variables
    
    var session: WCSession!
    var count: Int!
    var score1 = 0
    var score2 = 0
    var winnerText: String!
    var scoreText: String!
    

//MARK: viewDidLoad()
    
    //This function loads a session to watch when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    
//MARK: didReceiveMemoryWarning()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Session

    //This function connects with the watch to read data and use it on the phone. The session runs on a background thread which does not work well if you want to update UI elements. It then calls the timesUp() method with the timer from the watch is at 0
    func session(session: WCSession, didReceiveMessage gameStats: [String : AnyObject]) {
        if let gameStatsScores = gameStats["Scores"] as? [Int] {
            count = gameStatsScores[0]
            score1 = gameStatsScores[1]
            score2 = gameStatsScores[2]
            //This method allows you to jump from the background thread that the session is in to the main thread to update the UI
            dispatch_async(dispatch_get_main_queue()) {
                self.timerLabel.text = String(gameStatsScores[0])
                self.player1Score.text = String(self.score1)
                self.player2Score.text = String(self.score2)
            }
        }
        if count == 0 {
            timesUp()
        }
    }
    
    
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
        self.performSegueWithIdentifier("endOfGameFromScoreboardSegue", sender: self)
    }
    
    
//MARK: Action Functions
    
    //This function runs an unwind segue when the exit button is tapped
    @IBAction func exitButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("exitSegue", sender: self)
    }
    
    
//MARK: Segues

    ///This function holds the info needed when a segue is called from the SwipeViewController. It checks to see which segue is called (either the regular one or the unwind segue) and does the appropriate actions to make it work
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