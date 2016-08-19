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
    
    //This function sends a message to PhoneSession with the key tellPhoneToBeTheController
    func tellPhoneToBeTheController() {
        let actionDictFromWatch = ["Action": "tellPhoneToBeTheController"]
        session.sendMessage(actionDictFromWatch, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    //This function sends a message to PhoneSession with the key tellPhoneToBeTheScoreboard
    func tellPhoneToBeTheScoreboard() {
        let actionDictFromWatch = ["Action": "tellPhoneToBeTheScoreboard"]
        session.sendMessage(actionDictFromWatch, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    //This function sends a message to PhoneSession with a dictionary containing a tellPhoneToStartGame value
    func tellPhoneToStartGame(time: NSTimeInterval) {
        let payloadDictFromWatch = ["Time": time]
        let actionDictFromWatch = ["Action": "tellPhoneToStartGame", "Payload": payloadDictFromWatch]
        session.sendMessage(actionDictFromWatch as! [String : AnyObject], replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    //This function sends a message to PhoneSession with the key tellPhoneToStopGame
    func tellPhoneToStopGame() {
        let actionDictFromWatch = ["Action": "tellPhoneToStopGame"]
        session.sendMessage(actionDictFromWatch, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    //This function sends a message to PhoneSession with a dictionary containing a startRunToPhone value
    func tellPhoneScoreData(score1: Int, score2: Int) {
        let payloadDictFromWatch = ["Score1": score1, "Score2": score2]
        let actionDictFromWatch = ["Action": "tellPhoneScoreData", "Payload": payloadDictFromWatch]
        session.sendMessage(actionDictFromWatch as! [String : AnyObject], replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    
//MARK: Data Getters
    
    //This functions receives a message from the Watch
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(message["Action"]! as! String, object: message["Payload"])
        }
    }
    
}