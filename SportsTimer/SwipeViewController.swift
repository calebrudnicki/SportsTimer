//
//  SwipeViewController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 6/23/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController {
    
    @IBOutlet weak var swipeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SwipeViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SwipeViewController.handleSwipes(_:)))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Left {
            self.view.backgroundColor = UIColor.blueColor()
        }
        
        if sender.direction == .Right {
            self.view.backgroundColor = UIColor.redColor()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
