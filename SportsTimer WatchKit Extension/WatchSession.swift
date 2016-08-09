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
    
    //This function sends a message to PhoneSession with the key tellPhoneToStopGame
    func tellPhoneToStopGame() {
        let actionDictFromWatch = ["Action": "tellPhoneToStopGame"]
        session.sendMessage(actionDictFromWatch, replyHandler: nil) { (error: NSError) in
            print(error)
        }
    }
    
    //This functions either transfers or sends a message to PhoneSession with the key givePhoneAllData depending on whether the watch face is on or off
    func givePhoneAllData(time: NSTimeInterval, score1: Int, score2: Int) {
        let payloadDictFromWatch = ["Time": time, "Score1": score1, "Score2": score2]
        let actionDictFromWatch = ["Action": "givePhoneAllData", "Payload": payloadDictFromWatch]
        if session.activationState == .Activated {
            session.sendMessage(actionDictFromWatch, replyHandler: nil) { (error: NSError) in
                print(error)
            }
        } else {
            session.transferUserInfo(actionDictFromWatch)
        }

    }
    
}