//
//  HomeInterfaceController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 8/8/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import WatchKit
import Foundation

class HomeInterfaceController: WKInterfaceController {

//MARK: Boilerplate Functions
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    //This functions makes a shared instance of watch session
    override func willActivate() {
        super.willActivate()
        WatchSession.sharedInstance.startSession()
        WatchSession.sharedInstance.tellPhoneToStopGame()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
//MARK: Actions

    //This function segues to the ScoreboardInterfaceController when the start run button is tapped
    @IBAction func startGameButtonTapped() {
        self.presentControllerWithName("Scoreboard Interface Controller", context: nil)
    }
    
}