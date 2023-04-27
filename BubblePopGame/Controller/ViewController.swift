//
//  ViewController.swift
//  BubblePopGame
//
//  Created by Sakura Adachi on 17/4/23.
//

// The main View of the game.
// The user can start the game with the Play button.
import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    static var backGroundMusic: AVAudioPlayer!
    let userDefaults = UserDefaults()
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var scoreBtn: UIButton!
    @IBOutlet var settingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Prepare to play the background music
        guard let soundURL = Bundle.main.url(forResource: "pokemonBGM", withExtension: "mp3") else {
                    print("Error: Failed to find popSound.mp3 file")
                    return
                }
        do {
            try ViewController.backGroundMusic = AVAudioPlayer(contentsOf: soundURL)
            ViewController.backGroundMusic.prepareToPlay()

        } catch let error as NSError {
            print(error.description)
        }
        // Start playing the background music
        ViewController.backGroundMusic.play()
        // If the user lacks of the setting data, set the default value.
        if userDefaults.integer(forKey: "gameTime") == 0 {
            // The length of the game. Able to change from Settings.
            userDefaults.set(60, forKey: "gameTime")
        }
        if userDefaults.integer(forKey: "bubblesNumber") == 0 {
            // The number of the bubbles. Able to change from Settings.
            userDefaults.set(15, forKey: "bubblesNumber")
        }
        if userDefaults.integer(forKey: "highScore") == 0 {
            // The highest score in the game.
            userDefaults.set(0, forKey: "highScore")
        }
        if userDefaults.dictionary(forKey: "highscorePeople") == nil {
            // The people who played the game is ranked and listed on this dictionary.
            userDefaults.set(["Default": 0], forKey: "highscorePeople")
        }
        if userDefaults.string(forKey: "popSound") == nil {
            // If sound to pop a bubble is on or not
            userDefaults.set("on", forKey: "popSound")
        }
        
        // Register a user
        showUserNameAlert()
        }
    
    // Register a user in userDefaults
    func showUserNameAlert() {
        // Define an Alert UI component
        let alertController = UIAlertController(title: "Enter your name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        // Define an OK button to confirm the regisration of the user
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let textField = alertController.textFields![0] as UITextField
            
            if let name = textField.text, !name.isEmpty {
                self.userDefaults.set(name, forKey: "playerName")
            } else {
                self.userDefaults.set("Player", forKey: "playerName")
            }
            self.userDefaults.set(textField.text, forKey: "playerName")
        }
        
        // Put okAction on the Alert component
        alertController.addAction(okAction)
        
        // Show the alert on the screen
        present(alertController, animated: true, completion: nil)
    }
}

