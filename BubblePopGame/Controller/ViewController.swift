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
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
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
//        ViewController.backGroundMusic.play()
        
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
            // Get userName from Text fields in Alert component
            let textField = alertController.textFields![0] as UITextField
            
            // If the User name is there, save it in UserDefaults
            if let name = textField.text, !name.isEmpty {
                Helper.shared.set(name, forKey: "playerName")
            } else {
                // If the text field is empty, show a confirmation alert
                let confirmAlertController = UIAlertController(title: "Do you wish to continue with name as \"Player\"?", message: nil, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                    // If "Yes" is selected, save the default username to UserDefaults
                    Helper.shared.set("Player", forKey: "playerName")
                }
                let noAction = UIAlertAction(title: "No", style: .cancel) { (_) in
                    // If "No" is selected, go back to the original alert to enter a name
                    self.showUserNameAlert()
                }
                confirmAlertController.addAction(yesAction)
                confirmAlertController.addAction(noAction)
                self.present(confirmAlertController, animated: true, completion: nil)
                return
            }
        }
        
        // Put okAction on the Alert component
        alertController.addAction(okAction)
        
        // Show the alert on the screen
        present(alertController, animated: true, completion: nil)
    }
}

