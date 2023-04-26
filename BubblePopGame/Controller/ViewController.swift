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
    
    static var gameBGMusic: AVAudioPlayer!
    let url = Bundle.main.url(forResource: "pokemonBGM", withExtension: "mp3")
    let userDefaults = UserDefaults()
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var scoreBtn: UIButton!
    @IBOutlet var settingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                do {
                    try ViewController.gameBGMusic = AVAudioPlayer(contentsOf: url!)
                    ViewController.gameBGMusic.prepareToPlay()

                } catch let error as NSError {
                    print(error.description)
                }
                ViewController.gameBGMusic.play()
                // Check if user hasn't entered any settings
                if userDefaults.integer(forKey: "gameTime") == 0 {
                    userDefaults.set(60, forKey: "gameTime")
                }
                if userDefaults.integer(forKey: "noBubbles") == 0 {
                    userDefaults.set(15, forKey: "noBubbles")
                }
                if userDefaults.integer(forKey: "highScore") == 0 {
                    userDefaults.set(0, forKey: "highScore")
                }
                if userDefaults.dictionary(forKey: "highscorepeople") == nil {
                    userDefaults.set(["Default": 0], forKey: "highscorepeople")
                }
                if userDefaults.string(forKey: "hitSound") == nil {
                    userDefaults.set("on", forKey: "hitSound")
                }
                print(userDefaults.dictionary(forKey: "highscorepeople")!)
                showUserNameAlert()
        }
        
    func showUserNameAlert() {
        let alertController = UIAlertController(title: "Enter your name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
                
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let textField = alertController.textFields![0] as UITextField
            
            if let name = textField.text, !name.isEmpty {
                self.userDefaults.set(name, forKey: "playerName")
            } else {
                self.userDefaults.set("Player", forKey: "playerName")
            }
            self.userDefaults.set(textField.text, forKey: "playerName")
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

