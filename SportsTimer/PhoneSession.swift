//
//  PhoneSession.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 8/7/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import WatchConnectivity

class PhoneSession: NSObject, WCSessionDelegate {
    
//MARK: Variables
    
    static let sharedInstance = PhoneSession()
    var session: WCSession!
    
    
//MARK: Session Creation
    
    //This function creates a session
    func startSession() {
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    
//MARK: Data Getters
    
    //This functions receives a message from the Watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: message["Action"]! as! String), object: message["Payload"])
        }
    }
    
    
//MARK: Watch Connectivity
    
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
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("sessionDidDeactivate")
        
        // Begin the activation process for the new Apple Watch.
        WCSession.default().activate()
    }
    
}
