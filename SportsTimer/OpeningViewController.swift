//
//  OpeningViewController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 7/24/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController {
    
//MARK: Boilerplate Functions

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Actions
    
    @IBAction func continueButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("continueToHomeSegue", sender: self)
    }
    
    
//MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "continueToHomeSegue" {
                let homeViewController = segue.destinationViewController as! HomeViewController
            }
        }
    }

}