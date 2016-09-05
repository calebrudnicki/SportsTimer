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
    
//MARK: Session Creation
    
    //This function creates a session
    func startSession() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    

//MARK: Data Senders
    
    //This function sends a message to PhoneSession with the key tellPhoneToBeTheController
    func tellPhoneToBeTheController() {
        let actionDictFromWatch = ["Action": "tellPhoneToBeTheController"]
        sendMessage(messageDict: actionDictFromWatch)
    }

    //This function sends a message to PhoneSession with the key tellPhoneToBeTheScoreboard
    func tellPhoneToBeTheScoreboard() {
        let actionDictFromWatch = ["Action": "tellPhoneToBeTheScoreboard"]
        sendMessage(messageDict: actionDictFromWatch)
    }
    
    //This function sends a message to PhoneSession with a dictionary containing a tellPhoneToStartGame value
    func tellPhoneToStartGame(_ time: TimeInterval) {
        let payloadDictFromWatch = ["Time": time]
        sendMessage(messageDict: payloadDictFromWatch)
    }
    
    //This function sends a message to PhoneSession with the key tellPhoneToStopGame
    func tellPhoneToStopGame() {
        let actionDictFromWatch = ["Action": "tellPhoneToStopGame"]
        sendMessage(messageDict: actionDictFromWatch)
    }
    
    //This function sends a message to PhoneSession with a dictionary containing a startRunToPhone value
    func tellPhoneScoreData(_ score1: Int, score2: Int) {
        let payloadDictFromWatch = ["Score1": score1, "Score2": score2]
        let actionDictFromWatch = ["Action": "tellPhoneScoreData", "Payload": payloadDictFromWatch] as [String : Any]
        sendMessage(messageDict: actionDictFromWatch)
    }
    
   //This functions manually sends message to the phone
    func sendMessage (messageDict: [String : Any]) {
        WCSession.default().sendMessage(messageDict, replyHandler: { (replyDict) -> Void in
            print("replyDict \(replyDict)")
            }, errorHandler: { (error) -> Void in
                print(error)
                print("there's an error") })
    }
    
    
//MARK: Data Getters
    
    //This functions receives a message from the Watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: message["Action"]! as! String), object: message["Payload"])
        }
    }

    
//MARK: Phone Connectivity

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == WCSessionActivationState.activated {
            NSLog("Activated")
        }
        
        if activationState == WCSessionActivationState.inactive {
            NSLog("Inactive")
        }
        
        if activationState == WCSessionActivationState.notActivated {
            NSLog("NotActivated")
        }
    }
    
/*
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("sgoessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("sessionDidDeactivate")
        
        // Begin the activation process for the new Apple Watch.
          WCSession.default().activate()
    }
*/
    
}
