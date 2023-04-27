//
//  UserDefaultsHelper.swift
//  BubblePopGame
//
//  Created by Sakura Adachi on 27/4/2023.
//

import Foundation

class Helper {

    static let shared = Helper()
    private let defaults = UserDefaults.standard
    
    private init() {
        initializeDefaults()
    }

    func set(_ value: Any?, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    func string(forKey key: String) -> Any? {
        return defaults.string(forKey: key)!
    }
    
    func integer(forKey key: String) -> Int {
        return defaults.integer(forKey: key)
    }
    
    func dictionary(forKey key: String) -> [String : Any?] {
        return defaults.dictionary(forKey: key)!
    }
    
    private func initializeDefaults() {

           if defaults.integer(forKey: "gameTime") == 0 {
                // The length of the game. Able to change from Settings.
                defaults.set(60, forKey: "gameTime")
            }
           if defaults.integer(forKey: "bubblesNumber") == 0 {
               defaults.set(15, forKey: "bubblesNumber")
           }
           if defaults.integer(forKey: "highScore") == 0 {
               defaults.set(0, forKey: "highScore")
           }
           if defaults.dictionary(forKey: "highscorePeople") == nil {
               defaults.set(["Default": 0], forKey: "highscorePeople")
           }
           if defaults.string(forKey: "popSound") == nil {
               defaults.set("on", forKey: "popSound")
           }
       }

}

