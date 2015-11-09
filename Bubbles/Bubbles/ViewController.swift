//
//  ViewController.swift
//  Bubbles
//
//  Created by Joe E. on 11/9/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import AVFoundation

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
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController : AVCaptureAudioDataOutputSampleBufferDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        guard let channel = connection.audioChannels.first where channel.averagePowerLevel > -5 else { return print("notBlowing") }
        print("Blowing")
        
        let bubble = UIView(frame:CGRect(origin: CGPointZero, size: CGSize(width: 50, height: 50)))
//        bubble.layer.masksToBounds = false
        bubble.layer.cornerRadius = 25
        bubble.layer.borderColor = UIColor.cyanColor().CGColor
        bubble.layer.borderWidth = 1
        bubble.center = CGPoint(x: view.frame.midX, y: view.frame.maxY)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.view.addSubview(bubble)
            let randomDuration = 2.00
            
            UIView.animateWithDuration(randomDuration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                bubble.center.y = self.view.center.y
                
                }) { (Bool) -> Void in
                    bubble.removeFromSuperview()
                    
            }
            
        }
        
    }
    
}
