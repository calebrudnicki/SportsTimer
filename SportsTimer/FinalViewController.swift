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
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
  
    
//MARK: Variables
    
    var introText = ""
    var winnerText = ""
    var resultText = ""
    var scoreText = ""
    
    
//MARK: viewDidLoad()
    
    //This function assigns all of the labels to their respective string values from SwipeViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        introLabel.text = introText
        winnerLabel.text = winnerText
        resultLabel.text = resultText
        scoreLabel.text = scoreText
    }

    
//MARK: didReceiveMemoryWarning()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
