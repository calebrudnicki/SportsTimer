//
//  ScoreboardViewController.swift
//  SportsTimer
//
//  Created by Caleb Rudnicki on 7/6/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ScoreboardViewController: UIViewController {
    
//MARK: Outlets
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var player1TitleLabel: UILabel!
    @IBOutlet weak var player2TitleLabel: UILabel!
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var tutorialStack: UIStackView!
    @IBOutlet weak var timeSlider: UISlider!
    
//MARK: Variables
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var timer: Timer!
    var totalTime: Int! = 600
    var player1Score: Int! = 0
    var player2Score: Int! = 0
    var updatedWatchTimer: Int!
    var timerIsOn: Bool = false
    var canScoreFromPhone = true
    
    
//MARK: Boilerplate Functions
    
    //This function creates an instance of a shared session, establishes this class as an observer of the tellPhoneToBeTheScoreboard, tellPhoneToBeTheController, tellPhoneToStartGame, tellPhoneToStopGame, tellPhoneScoreData, and tellPhoneTheTime notifications, and calls addSwipe()
    override func viewDidLoad() {
        super.viewDidLoad()
        PhoneSession.sharedInstance.startSession()
        NotificationCenter.default.addObserver(self, selector: #selector(ScoreboardViewController.receivedTellPhoneToBeTheControllerNotification(_:)), name:NSNotification.Name(rawValue: "tellPhoneToBeTheController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScoreboardViewController.receivedTellPhoneToBeTheScoreboardNotification(_:)), name:NSNotification.Name(rawValue: "tellPhoneToBeTheScoreboard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScoreboardViewController.receivedTellPhoneToStartGameNotification(_:)), name:NSNotification.Name(rawValue: "tellPhoneToStartGame"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScoreboardViewController.receivedTellPhoneToStopGameNotification(_:)), name:NSNotification.Name(rawValue: "tellPhoneToStopGame"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScoreboardViewController.receivedTellPhoneScoreDataNotification(_:)), name:NSNotification.Name(rawValue: "tellPhoneScoreData"), object: nil)
        self.addSwipe()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This function removes itself as an observer when the view disappears
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    

//MARK: Layout Functions
    
    //This function formats the screen to show that it is active
    func activatePhone() {
        canScoreFromPhone = true
        self.restartGame()
        view.backgroundColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1)
        timerLabel.textColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        player1TitleLabel.textColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        player2TitleLabel.textColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        player1ScoreLabel.textColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        player2ScoreLabel.textColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        self.layoutWithTutorial()
    }
    
    //This function formats the screen to show that it is inactive
    func deactivatePhone() {
        canScoreFromPhone = false
        self.restartGame()
        view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        timerLabel.textColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1)
        player1TitleLabel.textColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1)
        player2TitleLabel.textColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1)
        player1ScoreLabel.textColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1)
        player2ScoreLabel.textColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1)
        self.layoutWithoutTutorial()
    }
    
    //This function changes the layout of the labels when the tutorial is on
    func layoutWithTutorial() {
        tutorialStack.isHidden = false
        timerLabel.alpha = 0.25
        player1TitleLabel.alpha = 0.25
        player2TitleLabel.alpha = 0.25
        player1ScoreLabel.alpha = 0.25
        player2ScoreLabel.alpha = 0.25
        timeSlider.isHidden = false
    }
    
    //This function changes the layout of the labels when the tutorial is off
    func layoutWithoutTutorial() {
        tutorialStack.isHidden = true
        timerLabel.alpha = 1
        player1TitleLabel.alpha = 1
        player2TitleLabel.alpha = 1
        player1ScoreLabel.alpha = 1
        player2ScoreLabel.alpha = 1
        timeSlider.isHidden = true
    }
    
    
//MARK: Watch Communication Functions
    
    //This function that gets called everytime a tellPhoneToBeTheController notification is posted calls activatePhone()
    func receivedTellPhoneToBeTheControllerNotification(_ notification: Notification) {
        self.activatePhone()
    }
    
    //This function that gets called everytime a tellPhoneToBeTheScoreboard notification is posted calls deactivatePhone()
    func receivedTellPhoneToBeTheScoreboardNotification(_ notification: Notification) {
        self.deactivatePhone()
    }
    
    //This function that gets called everytime a tellPhoneToStartGame notification is posted calls startTimer()
    func receivedTellPhoneToStartGameNotification(_ notification: Notification) {
        let dataDict = notification.object as? [String : AnyObject]
        self.startTimer(dataDict!)
    }
    
    //This function that gets called everytime the tellPhoneToStopGame notification is posted calls restartGame()
    func receivedTellPhoneToStopGameNotification(_ notification: Notification) {
        self.restartGame()
    }
    
    //This function that gets called everytime a tellPhoneScoreData notification is posted calls displayLabels()
    func receivedTellPhoneScoreDataNotification(_ notification: Notification) {
        let dataDict = notification.object as? [String : AnyObject]
        self.displayLabels(dataDict!)
    }
    
    
//MARK; Actions
    
    //This functions sets the time of the game based on the slider
    @IBAction func totalTimeChanged(_ sender: AnyObject) {
        totalTime = Int(timeSlider.value * 100)
    }
    
    

//MARK: Swipe Functions
    
    //This funtions creates the swipe gestures and then adds them to the view
    func addSwipe() {
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .down, .up]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(ScoreboardViewController.handleSwipe(_:)))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }
    
    //This functions handles each swipe and its functionality within the app
    func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction.rawValue == 1 && canScoreFromPhone == true && timerIsOn == true {
            player1Score = player1Score + 1
            player1ScoreLabel.text = String(player1Score)
        } else if sender.direction.rawValue == 2 && canScoreFromPhone == true  && timerIsOn == true {
            player2Score = player2Score + 1
            player2ScoreLabel.text = String(player2Score)
        } else if sender.direction.rawValue == 8 && canScoreFromPhone == true && timerIsOn == false {
            self.beginClock()
            self.layoutWithoutTutorial()
        } else if sender.direction.rawValue == 4 && canScoreFromPhone == true && timerIsOn == true {
            self.restartGame()
            self.layoutWithTutorial()
        }
    }
    
    
//MARK: Label Functions
    
    //This function restarts a game by resetting labels and variables while also invalidating the timer
    func restartGame() {
        timerIsOn = false
        if timer != nil {
           timer.invalidate()
        }
        totalTime = 600
        timerLabel.text = "10:00"
        player1Score = 0
        player2Score = 0
        player1ScoreLabel.text = "0"
        player2ScoreLabel.text = "0"
    }
    
    //This functions updates the score labels to match the watch's data
    func displayLabels(_ dataDict: [String : AnyObject]) {
        player1ScoreLabel.text = String(describing: dataDict["Score1"]!)
        player2ScoreLabel.text = String(describing:dataDict["Score2"]!)
        player1Score = Int(String(describing: dataDict["Score1"]!))
        player2Score = Int(String(describing: dataDict["Score2"]!))
    }
    
    //This functions runs once per second until the totalTime variable reaches 0 before it calls timesUp() with the winning player as a parameter
    func eachSecond(_ timer: Timer) {
        if totalTime == 300 && player1Score > player2Score {
            if player1Score > player2Score {
                let statusNotice = AVSpeechUtterance(string: "Half of the game has passed. Player 1 is winning \(player1Score) to \(player2Score)")
                self.speechSynthesizer.speak(statusNotice)
            } else {
                let statusNotice = AVSpeechUtterance(string: "Half of the game has passed. Player 2 is winning \(player2Score) to \(player1Score)")
                self.speechSynthesizer.speak(statusNotice)
            }
        }
        if totalTime == 60 {
            let statusNotice = AVSpeechUtterance(string: "One minute remaining")
            self.speechSynthesizer.speak(statusNotice)
        }
        if totalTime >= 0 {
            timerLabel.text = self.convertSeconds(totalTime)
        } else {
            timer.invalidate()
        }
        if totalTime == 0 {
            if self.player1Score > self.player2Score {
                self.timesUp("Player1")
            } else if self.player2Score > self.player1Score {
                self.timesUp("Player2")
            } else {
                self.timesUp("Tie")
            }
        }
        totalTime = totalTime - 1
    }
    
    
//MARK: Timer Functions
    
    //This functions sets totalTime to the amount of starting time on the watch and then creates a timer that calls eachSecond()
    func startTimer(_ dataDict: [String : AnyObject]) {
        DispatchQueue.main.async {
            if self.timerIsOn == false {
                self.totalTime = Int(String(describing: dataDict["Time"]!))!
                self.beginClock()
            }
        }
    }
    
    //This function starts the clock
    func beginClock() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ScoreboardViewController.eachSecond(_:)), userInfo: nil, repeats: true)
        self.timerIsOn = true
    }
    
    //This functions gets called when the time is up and determines which player is the winner
    func timesUp(_ winner: String) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if winner == "Player1" {
            player1ScoreLabel.textColor = UIColor.green
            player2ScoreLabel.textColor = UIColor.red
        } else if winner == "Player2" {
            player2ScoreLabel.textColor = UIColor.green
            player1ScoreLabel.textColor = UIColor.red
        } else if winner == "Tie" {
            player1ScoreLabel.textColor = UIColor.blue
            player2ScoreLabel.textColor = UIColor.blue
        }
    }
    
    //This function converts seconds into the string format minutes:seconds
    func convertSeconds(_ seconds: Int) -> String {
        let secs: Double! = Double(seconds)
        let minutePlace = Int(floor(secs / 60).truncatingRemainder(dividingBy: 60))
        let secondPlace = Int(floor(secs).truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutePlace, secondPlace)
    }
    
}
