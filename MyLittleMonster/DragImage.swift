//
//  DragImage.swift
//  MyLittleMonster
//
//  Created by Forrest Collins on 1/6/16.
//  Copyright © 2016 helloTouch. All rights reserved.
//

import Foundation
import UIKit

// Custom class for a draggable image
class DragImage: UIImageView {
    
    var originalPosition: CGPoint!
    var dropTarget: UIView? // This can be an UIImage, but use a base UIView for all classes!
    
    // boilerplate initializer, called before layouts are laid out on screen
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // boilerplate initializer, called before layouts are laid out on screen
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //----------------------
    // MARK: - Touches Began
    //----------------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // store position to send object back to if not a good drag
        // self.center is the UIImageView's center
        originalPosition = self.center
    }
    
    //--------------------
    // MARK: Touches Moved
    //--------------------
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // grab very first object in the touches set if it exists
        if let touch = touches.first {
            
            // grab the location in the main view
            let position = touch.locationInView(self.superview)
            // self.center is the UIImageView's center
            self.center = CGPointMake(position.x, position.y)
        }
    }
    
    //--------------------
    // MARK: Touches Ended
    //--------------------
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // check if there is a touch or a target
        if let touch = touches.first, let target = dropTarget {
            
            // originally self.superview, but do this rendition b/c of UIStackView
            let position = touch.locationInView(self.superview?.superview)
            
            // see if image we dragged is on top of frame of Monster
            // check if rectangle Monster frame contains a point
            if CGRectContainsPoint(target.frame, position) {
                // post notification for observer to listen to
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onTargetDropped", object: nil))
            }
        }
        
        // in either case, we set image back to original position
        self.center = originalPosition
    }
}
