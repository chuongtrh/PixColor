//
//  CameraViewController.swift
//  livecolor
//
//  Created by Sam on 5/27/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import NextLevel

class CameraViewController: UIViewController {

    //MARK: Outlet


    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var viewCapture: UIView!

    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnPickPhoto: UIButton!
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var btnFlash: UIButton!
    
    //MARK: Properties
    
    internal var focusView: FocusIndicatorView?
    internal var pivotPinchScale:CGFloat = 0
    

    //MARK: Life cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        
        setupUI()
        
        setupSession()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nextLevel = NextLevel.shared
        if nextLevel.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized  {
            do {
                try nextLevel.start()
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else {
            nextLevel.requestAuthorization(forMediaType: AVMediaTypeVideo)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    
        NextLevel.shared.stop()

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper function
    
    func setupUI(){
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        preview.backgroundColor = UIColor.black
        
        focusView = FocusIndicatorView(frame: .zero)

        btnFlash.setImage(#imageLiteral(resourceName: "shot-flash-off"), for: .normal)
        
        topView.backgroundColor = UIColor.clear
        bottomView.backgroundColor = UIColor.clear
        
        btnCapture.layer.borderWidth = 2
        btnCapture.layer.borderColor = UIColor.white.cgColor
    }
    
    func setupSession() {
        
        // Configure PreviewView
        NextLevel.shared.previewLayer.frame = preview.bounds
        preview.layer.addSublayer(NextLevel.shared.previewLayer)

        
        // Configure NextLevel by modifying the configuration ivars
        let nextLevel = NextLevel.shared
        nextLevel.captureMode = NextLevelCaptureMode.photo
        nextLevel.photoStabilizationEnabled = true
        nextLevel.deviceOrientation = .portraitUpsideDown
        
        nextLevel.delegate = self
        nextLevel.deviceDelegate = self
        nextLevel.flashDelegate = self
        nextLevel.photoDelegate = self
    }
    
    //MARK: Action

    @IBAction func actionChangeFlashMode(_ sender:AnyObject){
        let nextLevel = NextLevel.shared

        switch nextLevel.flashMode {
        case .on:
            NextLevel.shared.flashMode = .auto
            btnFlash.setImage(#imageLiteral(resourceName: "shot-flash-auto"), for: .normal)
            break
        case .off:
            NextLevel.shared.flashMode = .on
            btnFlash.setImage(#imageLiteral(resourceName: "shot-flash-on"), for: .normal)

            break
        case .auto:
            NextLevel.shared.flashMode = .off
            btnFlash.setImage(#imageLiteral(resourceName: "shot-flash-off"), for: .normal)
            break
        }
    }
    @IBAction func actionSwitchCamera(_ sender: AnyObject) {
        NextLevel.shared.flipCaptureDevicePosition()

    }
    @IBAction func actionCameraCapture(_ sender: AnyObject) {
        NextLevel.shared.capturePhoto()
    }

    @IBAction func onPinchGesture(gesture:UIPinchGestureRecognizer){
        switch gesture.state {
            case .began:
                self.pivotPinchScale = CGFloat(NextLevel.shared.videoZoomFactor)
            case .changed:
                var factor = self.pivotPinchScale * gesture.scale
                factor = max(1, min(factor, CGFloat(NextLevel.shared.videoZoomFactor)))
                NextLevel.shared.videoZoomFactor = Float(factor)
            default:
                break
        }
    }
    @IBAction func onTapgesture(gesture:UITapGestureRecognizer){
        
        let tapPoint:CGPoint = gesture.location(in: gesture.view)
        print("tapPoint:\(tapPoint)")

        if let focusView = self.focusView {
            var focusFrame = focusView.frame
            focusFrame.origin.x = CGFloat((tapPoint.x - (focusFrame.size.width * 0.5)).rounded())
            focusFrame.origin.y = CGFloat((tapPoint.y - (focusFrame.size.height * 0.5)).rounded())
            focusView.frame = focusFrame
            preview?.addSubview(focusView)
            focusView.startAnimation()
        }
        let adjustedPoint = NextLevel.shared.previewLayer.captureDevicePointOfInterest(for: tapPoint)
        NextLevel.shared.focusExposeAndAdjustWhiteBalance(atAdjustedPoint: adjustedPoint)
    }
    
    @IBAction func onSelectPhoto(_ sender:AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: { complete in
            
        })
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGenaratePaletteViewControllerIdentifier" {
            let vc:GenaratePaletteViewController = segue.destination as! GenaratePaletteViewController
            vc.imageSource = sender as! UIImage
        }
    }
}


// MARK: - NextLevelDelegate

extension CameraViewController: NextLevelDelegate {
    
    // permission
    func nextLevel(_ nextLevel: NextLevel, didUpdateAuthorizationStatus status: NextLevelAuthorizationStatus, forMediaType mediaType: String) {
        print("NextLevel, authorization updated for media \(mediaType) status \(status)")
        if nextLevel.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized {
            do {
                try nextLevel.start()
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else if status == .notAuthorized {
            // gracefully handle when audio/video is not authorized
            print("NextLevel doesn't have authorization for audio or video")
            
            let alert = UIAlertController(title: "Notice!!",
                                          message: "Application is need to access camera phone. Go to Setting",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            })
            
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    // configuration
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration) {
    }
    
    // session
    func nextLevelSessionWillStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionWillStart")
    }
    
    func nextLevelSessionDidStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStart")
    }
    
    func nextLevelSessionDidStop(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStop")
    }
    
    // interruption
    func nextLevelSessionWasInterrupted(_ nextLevel: NextLevel) {
    }
    
    func nextLevelSessionInterruptionEnded(_ nextLevel: NextLevel) {
    }
    
    // preview
    func nextLevelWillStartPreview(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopPreview(_ nextLevel: NextLevel) {
    }
    
    // mode
    func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel) {
    }
    
}

extension CameraViewController: NextLevelDeviceDelegate {
    
    // position, orientation
    func nextLevelDevicePositionWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDevicePositionDidChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceOrientation deviceOrientation: NextLevelDeviceOrientation) {
    }
    
    // format
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceFormat deviceFormat: AVCaptureDeviceFormat) {
    }
    
    // aperture
    func nextLevel(_ nextLevel: NextLevel, didChangeCleanAperture cleanAperture: CGRect) {
    }
    
    // focus, exposure, white balance
    func nextLevelWillStartFocus(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopFocus(_  nextLevel: NextLevel) {
        if let focusView = self.focusView {
            if focusView.superview != nil {
                focusView.stopAnimation()
            }
        }
    }
    
    func nextLevelWillChangeExposure(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeExposure(_ nextLevel: NextLevel) {
//        if let focusView = self.focusView {
//            if focusView.superview != nil {
//                focusView.stopAnimation()
//            }
//        }
    }
    
    func nextLevelWillChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - NextLevelFlashDelegate

extension CameraViewController: NextLevelFlashAndTorchDelegate {
    
    func nextLevelDidChangeFlashMode(_ nextLevel: NextLevel) {
        print("nextLevelDidChangeFlashMode:%@",nextLevel.flashMode)
    }
    
    func nextLevelDidChangeTorchMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelTorchActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashAndTorchAvailabilityChanged(_ nextLevel: NextLevel) {
    }
    
}
// MARK: - NextLevelPhotoDelegate

extension CameraViewController: NextLevelPhotoDelegate {
    
    // photo
    func nextLevel(_ nextLevel: NextLevel, willCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
        
        if let dictionary = photoDict, let photoData = dictionary[NextLevelPhotoJPEGKey] {
            if let capturedImage = UIImage(data: photoData as! Data) {
                // Save our captured image to photos album
                self.performSegue(withIdentifier: "ShowGenaratePaletteViewControllerIdentifier", sender: capturedImage.fixOrientation())
            }
        }
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessRawPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevelDidCompletePhotoCapture(_ nextLevel: NextLevel) {
    }
    
}


// MARK: - KVO

private var CameraViewControllerNextLevelCurrentDeviceObserverContext = "CameraViewControllerNextLevelCurrentDeviceObserverContext"

extension CameraViewController {
    
    internal func addKeyValueObservers() {
        self.addObserver(self, forKeyPath: "currentDevice", options: [.new], context: &CameraViewControllerNextLevelCurrentDeviceObserverContext)
    }
    
    internal func removeKeyValueObservers() {
        self.removeObserver(self, forKeyPath: "currentDevice")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CameraViewControllerNextLevelCurrentDeviceObserverContext {
            //self.captureDeviceDidChange()
        }
    }
    
}

extension CameraViewController : AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        // Convert photo same buffer to a jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        // Initialise an UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            // Save our captured image to photos album
            self.performSegue(withIdentifier: "ShowGenaratePaletteViewControllerIdentifier", sender: image)

            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
//MARK: UIImagePickerControllerDelegate
extension CameraViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: false, completion: { () -> Void in
        })
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.performSegue(withIdentifier: "ShowGenaratePaletteViewControllerIdentifier", sender: pickedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in
        })
    }
}
