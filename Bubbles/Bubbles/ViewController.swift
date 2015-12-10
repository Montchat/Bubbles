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
    
    //To capture audio inputs to create the bubbles
    var session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Need to capture audio
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        
        //Needs a capture Device
        let captureInput = try? AVCaptureDeviceInput(device: captureDevice!)
        
        //Check to see if we can add an input. If so, add input
        if session.canAddInput(captureInput) {
            session.addInput(captureInput)
        }
        
        //Just as we need an audio input, we need an audio output
        let captureOutput = AVCaptureAudioDataOutput()
        captureOutput.setSampleBufferDelegate(self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
        
        //Check to see if we can add the output. If so, add output
        if session.canAddOutput(captureOutput) {
            session.addOutput(captureOutput)
        }
        //Starts the capture session when the view loads
        session.startRunning()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}