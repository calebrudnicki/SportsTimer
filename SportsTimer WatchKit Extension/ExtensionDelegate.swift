//
//  ExtensionDelegate.swift
//  SportsTimer WatchKit Extension
//
//  Created by Caleb Rudnicki on 6/23/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import WatchConnectivity

@available(watchOSApplicationExtension 3.0, *)
class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
            print("activating")
        }
        
        
    }
    
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
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        backgroundTasks.forEach { (task) in
            // Process the background task
            //     StatSessionController.willActivate()
            // Be sure to complete each task when finished processing.
            task.setTaskCompleted()
        }
    }
}
