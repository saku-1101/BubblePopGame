//
//  SettingsViewController.swift
//  BubblePopGame
//
//  Created by Sakura Adachi on 17/4/23.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bubblesNumberLabel: UILabel!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var maxBubblesSlider: UISlider!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!

    
    // Update maximum time given the players choice
    @IBAction func maxTimeSlider(_ sender: UISlider) {
        let maxTime = Int(sender.value)
        Helper.shared.set(maxTime, forKey: "gameTime")
        timeLabel.text = String(maxTime) + "s"
    }
    
    // Update maximum bubbles given the players choice
    @IBAction func maxBubblesSlider(_ sender: UISlider) {
        let maxBubbles = Int(sender.value)
        Helper.shared.set(maxBubbles, forKey: "bubblesNumber")
        bubblesNumberLabel.text = String(maxBubbles)
    }
    
    @IBAction func bgMusic(_ sender: UISwitch) {
        if sender.isOn {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
    }
    func playBackgroundMusic(){
        ViewController.backGroundMusic.play()
    }
    
    func stopBackgroundMusic() {
        ViewController.backGroundMusic.stop()
    }
    
    @IBAction func popSound(_ sender: UISwitch) {
        if sender.isOn {
            Helper.shared.set("on", forKey: "popSound")
        } else {
            Helper.shared.set("off", forKey: "popSound")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerName.text = Helper.shared.string(forKey: "playerName") as? String

        timerSlider.value = Float(Helper.shared.integer(forKey: "gameTime"))

        timeLabel.text = String(Helper.shared.integer(forKey: "gameTime")) + "s"

        maxBubblesSlider.value = Float(Helper.shared.integer(forKey: "bubblesNumber"))

        bubblesNumberLabel.text = String(Helper.shared.integer(forKey: "bubblesNumber"))
        
        guard Helper.shared.string(forKey: "popSound") as! String == "on" else{
            soundSwitch.setOn(false, animated: true)
            return
        }
        soundSwitch.setOn(true, animated: true)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Helper.shared.set(playerName.text, forKey: "playerName")
        playerName.resignFirstResponder()
        return true
    }
    
}
