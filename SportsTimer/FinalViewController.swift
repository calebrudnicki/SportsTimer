//
//  FinalViewController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 7/5/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {

//MARK: Outlets
    

    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
  
    
//MARK: Variables
    
    var playerText = ""
    var resultText = ""
    
    
//MARK: viewDidLoad()
    
    //This function assigns all of the labels to their respective string values from SwipeViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        playerLabel.text = playerText
        resultLabel.text = resultText
    }

    
//MARK: didReceiveMemoryWarning()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
