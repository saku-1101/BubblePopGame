//
//  PlayViewController.swift
//  BubblePopGame
//
//  Created by Sakura Adachi on 17/4/23.
//

import UIKit

class PlayViewController: UIViewController {
    
    // get global static user conditions
    let userDefaults = UserDefaults()

    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var countdownLbl: UILabel!
    
    // define default value
    var remainingTime = 60
    var score = 0
    var highscore = 0
    var timer = Timer()
    var bubble = Bubble()
    var maxBubbles = 0
    var bubbleStore = [Bubble]()
    var previousBubbleVlue = -1
    var highscoreDict = [String: Int]()
    var countDown = 4 // The 3, 2, 1...count down value before the game
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = String(score)
        
        countdownLabel.text = String(userDefaults.integer(forKey: "gameTime")) + "s"
        remainingTime = userDefaults.integer(forKey: "gameTime")
        highScoreLabel.text = String(userDefaults.integer(forKey: "highScore"))
        highscoreDict = userDefaults.dictionary(forKey: "leaderboard") as! [String: Int]
        
        //
        self.updateCountDown()
        
        // Activate timer, and generate bubble each second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            if self.countDown != 0{
                self.updateCountDown()
            }
            if self.countDown == 0{
                self.counting()
                self.deleteBubble()
                self.generateBubble()
            }
        }
    }
    
    //  update the 3,2,1... count down before the game starts. When countDown reaches 0, the label is removed from the parent view, and the game starts.
    func updateCountDown() {
        print(self.countDown)
        self.countdownLbl.text = String(self.countDown-1)
        countDown -= 1
        if (countDown==0){
            self.countdownLbl.removeFromSuperview()
        }
    }
    
    func updateUerScore(name: String){
        guard userDefaults.integer(forKey: name) == 0 else {
            // regular game player
            guard userDefaults.integer(forKey: name) < score else{
                return
            }
            userDefaults.set(score, forKey: name)
            highscoreDict.updateValue(score, forKey: name)
            userDefaults.set(highscoreDict, forKey: "leaderboard")
            return
        }
        // new game player
        userDefaults.set(score, forKey: name)
        highscoreDict.updateValue(score, forKey: name)
        userDefaults.set(highscoreDict, forKey: "leaderboard")
    }
    
    //  runs a countdown timer and displays the remaining time on a label as the time elapses. counting() method is called once per second and reduces the timer's time by one second. When the timer reaches zero, this method does the following
    @objc func counting() {
        remainingTime -= 1
        countdownLabel.text = String(remainingTime) + "s"
        
        // time over
        if remainingTime == 0 {
            timer.invalidate()
            
            // Checks the high score and stores the player's score.
            let playerName: String = userDefaults.string(forKey: "playerName")!
            updateUerScore(name: playerName)
            
            // Instantiate and display the HighScoreViewController.
            // Hides the back button of this scene.
            let vc = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    
    // bubble's overlap checker
    func isBubbleOverlapped(newBubble: Bubble) -> Bool {
        for aBubble in bubbleStore{
            if newBubble.frame.intersects(aBubble.frame){
                return true
            }
        }
        return false
    }

    @objc func generateBubble(){
        
        let noBubbles = userDefaults.integer(forKey: "noBubbles")
        // Rondomely generate the number of bubbles on the screen
        let randomInt = Int.random(in: 0...noBubbles)
        var i = 0
        while (i < randomInt && maxBubbles < noBubbles){
            // Create button object
            bubble = Bubble()
            // No overlap
            if (!isBubbleOverlapped(newBubble: bubble)){
                // Show button
                bubble.animation()
                self.view.addSubview(bubble)
                bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
                bubbleStore += [bubble]
                maxBubbles += 1
                i += 1
            }
        }
    }
    
    @objc func deleteBubble(){  // Remove bubbles every second
        
        let randomInt = Int.random(in: 0...bubbleStore.count)
        var i = 0
        
        while (i < randomInt){
            let rand = bubbleStore.randomElement()
            // remove count of bubble
            maxBubbles -= 1
            // remove bubble from superview
            rand!.removeFromSuperview()
            // remove bubble from array
            if let index = bubbleStore.firstIndex(of: rand!){
                bubbleStore.remove(at: index)
            }
            i += 1
        }
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        // Add points to score
        // If the kind of the bubble is the same as previous one, *1.5 the score.
        if (sender.bubbleValue == previousBubbleVlue){
            let multipliedScore = Double(sender.bubbleValue)*1.5
            score += Int(multipliedScore.rounded()) // can I round?
            previousBubbleVlue = sender.bubbleValue
        } else {
            score += sender.bubbleValue
            previousBubbleVlue = sender.bubbleValue
        }
        
        // Remove count of bubble
        maxBubbles -= 1
        
        // Remove bubble from bubbleStore when pressed
        if let index = bubbleStore.firstIndex(of: sender.self) {
            bubbleStore.remove(at: index)
        }
        
        // Change the score in Label
        scoreLabel.text = String(score)
        
        // If the current score is higher than highscore, change the label and the value of highScore in userDeraults.
        if score > highscore {
            highScoreLabel.text = scoreLabel.text
            userDefaults.set(score, forKey: "highScore")
        }
        
        // Remove pressed bubble from view
        sender.popBubble()
        if (userDefaults.string(forKey: "hitSound") == "on"){
            sender.popingSound()
        }
    }


}
