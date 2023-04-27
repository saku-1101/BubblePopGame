//
//  PlayViewController.swift
//  BubblePopGame
//
//  Created by Sakura Adachi on 17/4/23.
//

// Main Game Screen
// The Game will start after 3,2,1... count down
// The current user's score is shown in the left
// The time limit is shown in the middle
// The highest score that among all the game players is displayed in the right
// The number of the bubbles is regulated on Settings
// The Time limit is regulated on Settings
// After remainingTime variable goes to 0, HighScore screen will automatically be shown.
import UIKit
import AVFoundation

class PlayViewController: UIViewController {
    
    let userDefaults = UserDefaults()

    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var countdownStartingLabel: UILabel!
    
    // define default value
    var remainingTime = 60
    var score = 0
    var highscore = 0
    var timer = Timer()
    var bubble = Bubble()
    var maxBubbles = 0
    var bubbleStore:[Bubble] = []
    var previousBubbleVlue = -1
    var highscoreDict = [String: Int]()
    var countDown = 4 // The 3, 2, 1...count down value before the game
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = String(score)
        
        countdownLabel.text = String(Helper.shared.integer(forKey: "gameTime")) + "s"
        remainingTime = Helper.shared.integer(forKey: "gameTime")
        highscore = Helper.shared.integer(forKey: "highScore")
        highScoreLabel.text = "\(highscore)"
        highscoreDict = Helper.shared.dictionary(forKey: "highscorePeople") as! [String: Int]
        
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
        self.countdownStartingLabel.text = String(self.countDown-1)
        countDown -= 1
        if (countDown==0){
            self.countdownStartingLabel.removeFromSuperview()
        }
    }
    
    // either updating an existing user's score or creating a new user's score record.
    func updateUerScore(name: String){
        guard Helper.shared.integer(forKey: name) == 0 else {
            // regular game player
            guard Helper.shared.integer(forKey: name) < score else{
                return
            }
            // update the score for regular player if this round's score is higher than before
            Helper.shared.set(score, forKey: name)
            highscoreDict.updateValue(score, forKey: name)
            Helper.shared.set(highscoreDict, forKey: "highscorePeople")
            return
        }
        // new game player
        Helper.shared.set(score, forKey: name)
        highscoreDict.updateValue(score, forKey: name)
        Helper.shared.set(highscoreDict, forKey: "highscorePeople")
        return
    }
    
    //  runs a countdown timer and displays the remaining time on a label as the time elapses. counting() method is called once per second and reduces the timer's time by one second. When the timer reaches zero, this method shows HighScore screen
    @objc func counting() {
        remainingTime -= 1
        countdownLabel.text = String(remainingTime) + "s"
        
        // time over
        if remainingTime == 0 {
            timer.invalidate()
            
            // Checks the high score and stores the player's score.
            let playerName: String = Helper.shared.string(forKey: "playerName") as! String
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
        
        let bubblesNumber = Helper.shared.integer(forKey: "bubblesNumber")
        // Rondomely generate the number of bubbles on the screen
        let randomInt = Int.random(in: 0...bubblesNumber)
        var i = 0
        while (i < randomInt && maxBubbles < bubblesNumber){
            // Create bubble
            bubble = Bubble()
            // No overlap
            if (!isBubbleOverlapped(newBubble: bubble)){
                // Show bubble
                bubble.showBubble()
                self.view.addSubview(bubble)
                bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
                bubbleStore += [bubble]
                maxBubbles += 1
                i += 1
            }
        }
    }
    
    // delete bubbles
    @objc func deleteBubble() {
        // If the bubble store is empty, there are no bubbles to delete.
        guard !bubbleStore.isEmpty else { return }
        
        // Determine the maximum number of bubbles to delete, which is the minimum of maxBubbles and the total number of bubbles.
        let maxToDelete = min(maxBubbles, Int.random(in: 1...bubbleStore.count))
        
        // Remove a random bubble from the bubble store and the superview for each iteration of the loop, up to maxToDelete times.
        for _ in 0..<maxToDelete {
            let randomIndex = Int.random(in: 0..<bubbleStore.count)
            let randomBubble = bubbleStore.remove(at: randomIndex)
            maxBubbles -= 1
            randomBubble.removeFromSuperview()
        }
        
        print("=====> Buble store \(bubbleStore.count)")
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
        
        // Change the score in Label
        scoreLabel.text = String(score)
        
        // If the current score is higher than highscore, change the label and the value of highScore in userDeraults.
        if score > highscore {
            highScoreLabel.text = scoreLabel.text
            Helper.shared.set(score, forKey: "highScore")
        }
        
        // Remove count of bubble
        maxBubbles -= 1
        
        // Remove bubble from bubbleStore when pressed
        if let index = bubbleStore.firstIndex(of: sender.self) {
            bubbleStore.remove(at: index)
        }

        // Remove pressed bubble from view
        sender.popBubble()
        if (Helper.shared.string(forKey: "popSound") as! String == "on"){
            popSound()
        }
    }
    
    var audioPlayer = AVAudioPlayer()
    // make bubble-removing sound
    func popSound(){
        guard let popSoundURL = Bundle.main.url(forResource: "popSound", withExtension: "mp3") else {
                    print("Error: Failed to find popSound.mp3 file")
                    return
                }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: popSoundURL)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print(error)
        }
    }


}
