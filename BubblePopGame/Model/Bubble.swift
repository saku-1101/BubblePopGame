//
//  Bubble.swift
//  BubblePopGame
//
//  Created by Leon Wang on 20/4/22.
//

import UIKit
import AVFoundation

class Bubble: UIButton {

    var bubbleValue: Int = 0
    var audioPlayer = AVAudioPlayer()
    
    // Screen dimensions
    let screenSize: CGRect = UIScreen.main.bounds
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: CGFloat(Int.random(in: 60...Int(screenSize.width - 90))),
                            y: CGFloat(Int.random(in: 150...Int(screenSize.height - 120))),
                            width: 80, height: 80) // 7.1
        
        // probability of each bubble appearing
        let possibility = Int(arc4random_uniform(100))
        switch possibility {
        case 0...39:
            self.setImage(UIImage(named: "Red-Bubble"), for: .normal)
            self.bubbleValue = 1
        case 40...69:
            self.setImage(UIImage(named: "Pink-Bubble"), for: .normal)
            self.bubbleValue = 2
        case 70...84:
            self.setImage(UIImage(named: "Green-Bubble"), for: .normal)
            self.bubbleValue = 5
        case 85...94:
            self.setImage(UIImage(named: "Blue-Bubble"), for: .normal)
            self.bubbleValue = 8
        case 95...99:
            self.setImage(UIImage(named: "Black-Bubble"), for: .normal)
            self.bubbleValue = 10
        default:
            return
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 0.8
        springAnimation.toValue = 1
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    func popBubble(){
        UIView.animate(withDuration: 0.4, animations: {
            self.transform = CGAffineTransform(scaleX: 5, y: 5)
            self.alpha = 0.2
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    
    func popingSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "hitsound", ofType: "mp4")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print(error)
        }
    }
}
