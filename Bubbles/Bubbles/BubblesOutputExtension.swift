//
//  BubblesOutputExtension.swift
//  Bubbles
//
//  Created by Joe E. on 12/10/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import AVFoundation

//This extension creates round UIViews with randomColors and creates a bubbles effect.
extension ViewController : AVCaptureAudioDataOutputSampleBufferDelegate {
    
    //function to create random colors
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        func getRandomColor(alpha: CGFloat) -> CGColor {
            let randomRed = CGFloat(drand48())
            let randomGreen = CGFloat(drand48())
            let randomBlue = CGFloat(drand48())
            
            //convert the UIColor to CGColor
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha).CGColor
        }
        
        func randomRange (lower: Int , upper: Int) -> CGFloat {
            return CGFloat(lower) + CGFloat(Int(arc4random_uniform(UInt32(upper - lower + 1))))
        }
        
        //if the volume from audio does not have a dB value of above -6, do nothing
        guard let channel = connection.audioChannels.first where channel.averagePowerLevel > -6 else { return print("notBlowing") }
        
        //width of bubbles. defined to be random
        let width = CGFloat(arc4random_uniform(45) + 1)
        
        //bubble height dependent on the absolute value of the peak hold level. we do the absolute value becaues the dB is a negative value
        let backgroundBubbleHeight = 100 * CGFloat(abs( 1 / channel.peakHoldLevel))
        
        //the UIView
        var bubble = UIView(frame:CGRect(origin: CGPointZero, size: CGSize(width: width, height: width)))
        
        // a separate static UIView. this UIView can get large enough to give off the illusion that the background of the view is changing color
        var backgroundBubble = UIView(frame: CGRect(x: view.frame.midX, y: view.frame.midY, width: backgroundBubbleHeight , height: backgroundBubbleHeight))
        
        //to make the views round
        bubble.layer.masksToBounds = false
        bubble.layer.cornerRadius = width / 2
        
        //getting the random colors *** function provided below
        bubble.layer.backgroundColor = getRandomColor(0.25)
        //geting the bubbles to appear from the bottom of the view, with a random x value
        bubble.center = CGPoint(x: CGFloat(arc4random_uniform(UInt32(view.frame.maxX))), y: view.frame.maxY)
        
        //for the other "UIView." this view will always be in the center. it has similar properties to the "bubble views"
        backgroundBubble.center = view.center
        backgroundBubble.alpha = 0.25
        backgroundBubble.layer.masksToBounds = false
        backgroundBubble.layer.cornerRadius = backgroundBubbleHeight / 2
        //making the static view a random color *** function provided below
        backgroundBubble.layer.backgroundColor = getRandomColor(0.50)
        
        //jumping back to the main thread so that the views can be added
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.view.addSubview(bubble)
            self.view.addSubview(backgroundBubble)
            
            
            //animating the background bubble
            UIView.animateWithDuration(1) { () -> Void in
                backgroundBubble.alpha = 0
                backgroundBubble.frame.size = CGSize(width: backgroundBubbleHeight, height: backgroundBubbleHeight)
                
            }
            
            
            //making the bubbles last for a random duration that is based on the absolutepowerlevel of audio decibels
            let randomDuration = Double(abs(1 / channel.averagePowerLevel)) * 6
            
            UIView.animateWithDuration(randomDuration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                //making the bubble center a random y value
                bubble.center.y = randomRange(Int(self.view.frame.minY) , upper: Int(self.view.frame.maxX))
                
                
                }) { (Bool) -> Void in
                    
                    //animating the removal of the subviews
                    UIView.animateWithDuration(0.50, animations: { () -> Void in
                        bubble.removeFromSuperview()
                        backgroundBubble.removeFromSuperview()
                        
                    })
            }
            
        }
        
        
    }

}
