//
//  ViewController.swift
//  Bubbles
//
//  Created by Joe E. on 11/9/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController {
    
    var session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        
        let captureInput = try? AVCaptureDeviceInput(device: captureDevice!)
        
        if session.canAddInput(captureInput) {
            session.addInput(captureInput)
        }
        
        let captureOutput = AVCaptureAudioDataOutput()
        captureOutput.setSampleBufferDelegate(self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        
        if session.canAddOutput(captureOutput) {
            session.addOutput(captureOutput)
        }
        
        session.startRunning()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

extension ViewController : AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        guard let channel = connection.audioChannels.first where channel.averagePowerLevel > -6 else { return print("notBlowing") }
        
        let width = CGFloat(arc4random_uniform(45) + 1)
        
        let backgroundBubbleHeight = 100 * CGFloat(abs( 1 / channel.peakHoldLevel))

        var bubble = UIView(frame:CGRect(origin: CGPointZero, size: CGSize(width: width, height: width)))
        
        var backgroundBubble = UIView(frame: CGRect(x: view.frame.midX, y: view.frame.midY, width: backgroundBubbleHeight , height: backgroundBubbleHeight))
        
        bubble.layer.masksToBounds = false
        bubble.layer.cornerRadius = width / 2
        
        bubble.layer.backgroundColor = getRandomColor(0.25)
        bubble.center = CGPoint(x: CGFloat(arc4random_uniform(UInt32(view.frame.maxX))), y: view.frame.maxY)
        
        backgroundBubble.center = view.center
        backgroundBubble.alpha = 0.25
        backgroundBubble.layer.masksToBounds = false
        backgroundBubble.layer.cornerRadius = backgroundBubbleHeight / 2
        
        backgroundBubble.layer.backgroundColor = getRandomColor(0.50)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.view.addSubview(bubble)
            self.view.addSubview(backgroundBubble)
            
            UIView.animateWithDuration(1) { () -> Void in
                backgroundBubble.alpha = 0
                backgroundBubble.frame.size = CGSize(width: backgroundBubbleHeight, height: backgroundBubbleHeight)

            }
            
            let randomDuration = Double(abs(1 / channel.averagePowerLevel)) * 6
            print(randomDuration)
            
            UIView.animateWithDuration(randomDuration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                bubble.center.y = self.randomRange(Int(self.view.frame.minY) , upper: Int(self.view.frame.maxX))

                
                }) { (Bool) -> Void in
                    UIView.animateWithDuration(0.50, animations: { () -> Void in
                        bubble.removeFromSuperview()
                        backgroundBubble.removeFromSuperview()
                        
                    })
            }
            
        }
        
    }
    
    func getRandomColor(alpha: CGFloat) -> CGColor {
        let randomRed = CGFloat(drand48())
        let randomGreen = CGFloat(drand48())
        let randomBlue = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha).CGColor
    }
    
    func randomRange (lower: Int , upper: Int) -> CGFloat {
        return CGFloat(lower) + CGFloat(Int(arc4random_uniform(UInt32(upper - lower + 1))))
    }
    
}

