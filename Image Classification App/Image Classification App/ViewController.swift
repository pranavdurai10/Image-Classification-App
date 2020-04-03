//
//  ViewController.swift
//  Image Classification App
//
//  Created by Pranav Durai  on 18/03/20.
//  Copyright © 2020 Pranav Durai. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate
{
    
    let identifierLabel: UILabel =
    {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        //start camera here
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice)
            else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        
        //VNImageRequestHandler(cgImage: <#T##CGImage#>, options: [:]).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
        setupIdentifierConfidenceLabel()
    }
    
    // Function for Confidence Label
    fileprivate func setupIdentifierConfidenceLabel()
    {
    view.addSubview(identifierLabel)
    identifierLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
    identifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    identifierLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    identifierLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    
    }
    // Function for Capturing each frame of the live feed from the iPhone's camera
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        //print("Camera was able to capture a frame:", Date())
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            else { return }
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model)
            else{ return }
        let request = VNCoreMLRequest(model: model)
        {
            (finishedReq, err) in
            //Check the errors and print
            //print(finishedReq.results)
            
            guard let results = finishedReq.results as? [VNClassificationObservation]
                else { return }
            
            guard let firstObservation = results.first else { return }
            print(firstObservation.identifier, firstObservation.confidence)
            DispatchQueue.main.async {
                self.identifierLabel.text = "\(firstObservation.identifier) \(firstObservation.confidence * 100)"
            }
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    
    
    }
    
   
    // End of function captureOutput
    
    
   
}


