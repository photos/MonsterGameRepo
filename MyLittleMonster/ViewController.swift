//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Forrest Collins on 1/6/16.
//  Copyright © 2016 helloTouch. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //-------------------
    // MARK: - UI Outlets
    //-------------------
    @IBOutlet weak var monsterImage: MonsterImage!
    // set user interaction enabled for both heart and food
    // in attributes inspector
    @IBOutlet weak var heartImage: DragImage!
    @IBOutlet weak var foodImage: DragImage!
    @IBOutlet weak var penaltyOneImage: UIImageView!
    @IBOutlet weak var penaltyTwoImage: UIImageView!
    @IBOutlet weak var penaltyThreeImage: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var currentPenalties = 0
    var timer: NSTimer!
    var monsterIsFed = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    //----------------------
    // MARK: - View Did Load
    //----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monsterImage.playIdleAnimation()
        
        // set low opacity for skull penalties
        penaltyOneImage.alpha = DIM_ALPHA
        penaltyTwoImage.alpha = DIM_ALPHA
        penaltyThreeImage.alpha = DIM_ALPHA
        
        // Set the dropTargets of the food and heart
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        
        // listen for notification that was posted
        // also put a colon after the selector because NSNotificationCenter looks 
        // for a function with a parameter
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        // play background music
        do {
            
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
    }
    
    //----------------------------------------------------------------------------
    // MARK: - Target Dropped on Monster, Reset Timer, Switch between Food & Heart
    //----------------------------------------------------------------------------
    func itemDroppedOnCharacter(notification: AnyObject) {
        // print("item dropped")
        monsterIsFed = true
        startTimer() // after the monster is fed
        
        // every time you drop an item on the monster, set items back to default value
        foodImage.alpha = DIM_ALPHA
        heartImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.userInteractionEnabled = false
        
        // play sound effects
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    //------------------
    // MARK: Start Timer
    //------------------
    func startTimer() {
        // stop previous timer from firing
        if timer != nil {
            timer.invalidate()
        }
        
        // calls changeGameState every 3 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    //-----------------------------------------
    // MARK: - Change Game State, Add Penalties
    //-----------------------------------------
    func changeGameState() {
        
        if !monsterIsFed {
            
            currentPenalties++
            
            sfxSkull.play()
            
            if currentPenalties == 1 {
                
                penaltyOneImage.alpha = OPAQUE
                penaltyTwoImage.alpha = DIM_ALPHA
                
            } else if currentPenalties == 2 {
                
                penaltyTwoImage.alpha = OPAQUE
                penaltyThreeImage.alpha = DIM_ALPHA
                
            } else if currentPenalties >= 3 {
                
                penaltyThreeImage.alpha = OPAQUE
                
            } else {
                
                // no penalties, force all back to dim
                penaltyOneImage.alpha = DIM_ALPHA
                penaltyTwoImage.alpha = DIM_ALPHA
                penaltyThreeImage.alpha = DIM_ALPHA
            }
            
            if currentPenalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2) // can get 0 or 1
        
        // make heart active
        if rand == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
            
        // make food active
        } else {
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
        }
        
        // store the current item so you know what sound effect to play
        currentItem = rand
        monsterIsFed = false // reset monster after it's fed
    }
    
    //------------------
    // MARK: - Game Over
    //------------------
    func gameOver() {
        timer.invalidate()
        monsterImage.playDeathAnimation()
        sfxDeath.play()
        
        // Reset the game!
        let delay = 2.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            
            self.viewDidLoad()
            self.currentPenalties = 0
            
        })
    }
}

