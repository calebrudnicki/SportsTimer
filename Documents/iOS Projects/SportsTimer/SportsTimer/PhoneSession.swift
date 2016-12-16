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
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
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