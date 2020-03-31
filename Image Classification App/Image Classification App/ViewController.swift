//
//  ViewController.swift
//  Image Classification App
//
//  Created by Pranav Durai  on 18/03/20.
//  Copyright © 2020 Pranav Durai. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        //start camera here
        
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice)
            else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
         
        
        
    }


}

