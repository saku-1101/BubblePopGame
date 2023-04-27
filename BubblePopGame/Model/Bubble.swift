//
//  Bubble.swift
//  BubblePopGame
//
//  Created by Sakura Adachi on 17/4/2023.
//

// Define a bubble obj and its functionalities
import UIKit
import AVFoundation

class Bubble: UIButton {

    let bubbleSize = CGSize(width: 80, height: 80)
    var bubbleValue = 0
    var audioPlayer = AVAudioPlayer()
    
    init() {
            super.init(frame: .zero)
            let maxX = UIScreen.main.bounds.width - bubbleSize.width - 30
            let maxY = UIScreen.main.bounds.height - bubbleSize.height - 30
            configureBubble(maxX: maxX, maxY: maxY)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureBubble(maxX: CGFloat, maxY: CGFloat) {
            // Set random position for bubble
            let randomX = CGFloat.random(in: 60...maxX)
            let randomY = CGFloat.random(in: 150...maxY)
            frame = CGRect(origin: CGPoint(x: randomX, y: randomY), size: bubbleSize)
            
            // Set bubble image and value based on probability
            let probability = Int.random(in: 0...99)
            switch probability {
            case 0...39:
                setImage(UIImage(named: "Red-Bubble"), for: .normal)
                bubbleValue = 1
            case 40...69:
                setImage(UIImage(named: "Pink-Bubble"), for: .normal)
                bubbleValue = 2
            case 70...84:
                setImage(UIImage(named: "Green-Bubble"), for: .normal)
                bubbleValue = 5
            case 85...94:
                setImage(UIImage(named: "Blue-Bubble"), for: .normal)
                bubbleValue = 8
            case 95...99:
                setImage(UIImage(named: "Black-Bubble"), for: .normal)
                bubbleValue = 10
            default:
                break
            }
        }
    // to show a bubble
    func showBubble() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 0.8
        springAnimation.toValue = 1
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    // to remove a bubble
    func popBubble(){
        UIView.animate(withDuration: 0.4, animations: {
            self.transform = CGAffineTransform(scaleX: 5, y: 5)
            self.alpha = 0.2
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    
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
