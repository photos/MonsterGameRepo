//
//  MonsterImg.swift
//  MyLittleMonster
//
//  Created by Forrest Collins on 1/6/16.
//  Copyright © 2016 helloTouch. All rights reserved.
//

import Foundation
import UIKit

// FYI: Set the Monster's class to MonsterImage in Identity Inspector

class MonsterImage: UIImageView {
    
    // boilerplate initializer, called before layouts are laid out on screen
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // boilerplate initializer, called before layouts are laid out on screen
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //----------------------------
    // MARK: - Play Idle Animation
    //----------------------------
    func playIdleAnimation() {
        
        clearImageArrayAndSetLastFrame("idle1")
        
        // load images from assets from an array
        var imageArray = [UIImage]()
        
        // use a sequence of the images and animate monster
        // fyi: you can implement this to make a custom loading spinner
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "idle\(x)")
            imageArray.append(img!)
        }
        
        // MonsterImg is the image
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0 // zero means infinite
        self.startAnimating()
    }
    
    //-----------------------------
    // MARK: - Play Death Animation
    //-----------------------------
    func playDeathAnimation() {
        
        clearImageArrayAndSetLastFrame("dead5")
        
        // load images from assets from an array
        var imageArray = [UIImage]()
        
        // use a sequence of the images and animate monster
        // fyi: you can implement this to make a custom loading spinner
        for var x = 1; x <= 5; x++ {
            let img = UIImage(named: "dead\(x)")
            imageArray.append(img!)
        }
        
        // MonsterImage is the image
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1 // plays once
        self.startAnimating()
    }
    
    //------------------------------------------
    // MARK: - Clear Image Array, Set Last Frame
    //------------------------------------------
    func clearImageArrayAndSetLastFrame(image: String) {
        
        // set default image for last frame
        self.image = UIImage(named: image)
        
        // when you reset your game, clear out array
        self.animationImages = nil
    }
}
