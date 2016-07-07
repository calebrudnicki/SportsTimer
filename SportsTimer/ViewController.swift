//
//  ViewController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 6/23/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//MARK: Outlets

    @IBOutlet weak var deviceSelector: UISegmentedControl!
    
    
//MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
//MARK: didReceieveMemoryWarning()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
//MARK: Action / Segue Functions
    
    //This function takes in all buttons connected to the Exit part of their view and allows them to return to this view controller when they are pressed
    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    //This functions determines which segue to travel on when the Start Game button is tapped
    @IBAction func startGame(sender: AnyObject) {
        switch deviceSelector.selectedSegmentIndex {
        case 0:
            self.performSegueWithIdentifier("startOfGameSwipeSegue", sender: self)
        case 1:
            self.performSegueWithIdentifier("startOfGameScoreboardSegue", sender: self)
        default:
            break
        }
    }

    //This function can be connected to a button to unwind a segue
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
    }
    
}