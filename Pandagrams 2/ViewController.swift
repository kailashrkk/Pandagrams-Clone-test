//
//  ViewController.swift
//  Pandagrams 2
//
//  Created by Kailash Ramaswamy on 30/09/15.
//  Copyright © 2015 NCh. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var filterOne: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var captureSession = AVCaptureSession()
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var stillImageOutput: AVCaptureStillImageOutput?
    var stillImage: UIImage?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var toggleCameraGesture =  UISwipeGestureRecognizer()
    
    var toggleAnimation = UISwipeGestureRecognizer()
    
    var toggleAnimationBack = UISwipeGestureRecognizer()
    
    var result = UIImage()
    
    var newImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        filterOne.image = UIImage(named: "star.png")
        
        filterOne.alpha = 0
        
        
        cameraButton.layer.cornerRadius = 37.5
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        for device in devices {
            if device.position == AVCaptureDevicePosition.Back{
                backCamera = device
            } else if device.position == AVCaptureDevicePosition.Front{
                frontCamera = device
            }
        }
        
        currentDevice = backCamera
        
        let currentInput = try! AVCaptureDeviceInput(device: currentDevice)
        
        stillImageOutput = AVCaptureStillImageOutput()
        
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        captureSession.addInput(currentInput)
        
        captureSession.addOutput(stillImageOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        view.layer.addSublayer(previewLayer!)
        
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        previewLayer?.frame = self.view.layer.frame
        
        view.bringSubviewToFront(cameraButton)
        
        captureSession.startRunning()
        
        toggleCameraGesture.direction = .Up
        
        toggleCameraGesture.addTarget(self, action: "switchCamera")
        
        view.addGestureRecognizer(toggleCameraGesture)
        
        toggleAnimation.direction = .Right
        
        toggleAnimation.addTarget(self, action: "bringStar")
        
        view.addGestureRecognizer(toggleAnimation)
        
        toggleAnimationBack.direction = .Left
        
        toggleAnimationBack.addTarget(self, action: "removeStar")
        
        view.addGestureRecognizer(toggleAnimationBack)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func capturePhoto(sender: AnyObject) {

 
        
        let videoConn = self.stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo)
        
        self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConn, completionHandler: { (actions, error) -> Void in
            
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(actions)
            
            self.stillImage = UIImage(data: imageData)
        
             self.newImage = self.stillImage!
            
            if self.filterOne.alpha == 0 {
            
             self.performSegueWithIdentifier("showPhoto", sender: self)
            } else{
                
                self.screenshot()
            }
        })
        
 
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPhoto" {
            
            let photoViewController = segue.destinationViewController as! PhotoViewController
            
            if filterOne.alpha == 0{
                
                photoViewController.image = stillImage!
                
            } else {
            
            
            photoViewController.image = result
            
            }
            
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        
        
    }
    
    func screenshot(){
        
        UIGraphicsBeginImageContext(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height))
        
        let wide = self.view.bounds.width
        let high = self.view.bounds.height
        
        self.newImage.drawInRect(CGRectMake(0, 0 , wide , high))
        
        if filterOne.alpha == 0 {
            
            print("No filter")
            
        } else {
            
            self.filterOne.drawRect(CGRectMake(50, 50
                , self.filterOne.frame.size.width, self.filterOne.frame.size.height))
            
        }
        
        self.result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            self.performSegueWithIdentifier("showPhoto", sender: self)
        }
    }
    
    func switchCamera(){
        
        captureSession.beginConfiguration()
        
        let newDevice = (currentDevice?.position == AVCaptureDevicePosition.Back) ? frontCamera : backCamera
        
        for input in captureSession.inputs{
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        let cameraInput = try! AVCaptureDeviceInput(device: newDevice)
        
        if captureSession.canAddInput(cameraInput){
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        
        captureSession.commitConfiguration()
    }

    func bringStar(){
        
        view.bringSubviewToFront(filterOne)
        
        let rotata = CATransform3DTranslate(CATransform3DIdentity, -500, 0, 0)
        
        filterOne.layer.transform = rotata
        
        UIView.animateWithDuration(1.0, animations: {[self.filterOne.alpha = 1, filterOne.layer.transform = CATransform3DIdentity]})
    }
    
    func removeStar(){
        
        if filterOne.alpha == 1 {
        
        view.bringSubviewToFront(filterOne)
        
        let rotata = CATransform3DTranslate(CATransform3DIdentity, 500, 0, 0)
        
        filterOne.layer.transform = rotata
        
        UIView.animateWithDuration(1.0, animations: {[self.filterOne.alpha = 0, filterOne.layer.transform = CATransform3DIdentity]})
            
        } else {
            
            print("No star to remove")
        }
    }
    
    
    
}

