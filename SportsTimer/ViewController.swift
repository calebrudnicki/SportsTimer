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
    @IBOutlet weak var startButton: UIButton!
    
    
//MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
//MARK: didReceieveMemoryWarning()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    
//MARK: viewWillAppear()
    
    //This functions sets some layout to the start button
    override func viewWillAppear(animated: Bool) {
        startButton.layer.borderWidth = 1
        startButton.layer.cornerRadius = startButton.frame.width / 2
    }

    
//MARK: Segues
    
    //This function takes in all buttons connected to the Exit part of their view and allows them to return to this view controller when they are pressed
    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    //This function can be connected to a button to unwind a segue
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
    }
    
    
//MARK: Action Functions
    
    //This functions determines which segue to travel on when the Start Game button is tapped
    @IBAction func startGame(sender: AnyObject) {
        switch deviceSelector.selectedSegmentIndex {
        case 0:
            self.performSegueWithIdentifier("startOfGameSwipeSegue", sender: self)
        case 1:
            watchAlert()
        default:
            break
        }
    }
    
    
//MARK: Alerts
    
    //This funtion sends an alert to the user and only allow he or she to go on if the okAction was selected
    func watchAlert() {
        let alertController = UIAlertController(title: nil, message: "Make sure your watch is ready before continuing", preferredStyle: .ActionSheet)
        let okAction = UIAlertAction(title: "Ok, I'm ready to play", style: .Default) { (action) in
            self.performSegueWithIdentifier("startOfGameScoreboardSegue", sender: self)
        }
        let notReadyAction = UIAlertAction(title: "Wait. I'm not ready yet", style: .Cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(notReadyAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}