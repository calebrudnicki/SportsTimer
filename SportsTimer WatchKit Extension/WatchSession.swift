//
//  WatchSession.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 8/7/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import WatchConnectivity

class WatchSession: NSObject, WCSessionDelegate {

//MARK: Variables
    
    static let sharedInstance = WatchSession()
    var session: WCSession!
    
    
//MARK: Session Creation
    
    //This function creates a session
    func startSession() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    
//MARK: Data Senders
    
    //This function sends a message to the PhoneSession with a dictionary containing a startRunToPhone value
    func givePhoneScoreData(countdown: NSTimeInterval, score1: Int, score2: Int) {
        let payloadDictFromWatch = ["Countdown": countdown, "Score1": score1, "Score2": score2]
        let actionDictFromWatch = ["Action": "givePhoneScoreData", "Payload": payloadDictFromWatch]
        session.sendMessage(actionDictFromWatch, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    
}
