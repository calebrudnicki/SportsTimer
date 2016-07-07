//
//  ScoreboardViewController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 7/6/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import WatchConnectivity

class ScoreboardViewController: UIViewController, WCSessionDelegate {

//MARK: Outlets
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    
    
//MARK: Variables
    
    var session: WCSession!
    

//MARK: viewDidLoad()
    
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

    //This function connects with the watch to read data and use it on the phone. The session runs on a background thread which does not work well if you want to update UI elements
    func session(session: WCSession, didReceiveMessage gameStats: [String : AnyObject]) {
        if let gameStatsScores = gameStats["Scores"] as? [Int] {
            //This method allows you to jump from the background thread that the session is in to the main thread to update the UI
            dispatch_async(dispatch_get_main_queue()) {
                self.timerLabel.text = String(gameStatsScores[0])
                self.player1Score.text = String(gameStatsScores[1])
                self.player2Score.text = String(gameStatsScores[2])
            }
        }
    }

}