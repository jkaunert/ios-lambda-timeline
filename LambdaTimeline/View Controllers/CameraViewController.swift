//
//  CameraViewController.swift
//  VideoRecorder
//
//  Created by TuneUp Shop  on 2/20/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    
    
    private let captureSession = AVCaptureSession()
    
    private let fileOutput = AVCaptureMovieFileOutput()
    @IBOutlet weak var cameraView: CameraPreviewView!
    
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up capture session
        
        // SESSION INPUTS
        let camera = bestCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Cant create an input device from camera. do better than this.")
        }
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("Session cant handle this type of input")
        }
        
        captureSession.addInput(cameraInput)
        
        // SESSION OUTPUTS
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("cannot record file")
        }
        captureSession.addOutput(fileOutput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }else {
            captureSession.sessionPreset = .high
        }
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    @IBAction func toggleRecord(_ sender: Any) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        }else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate Methods
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
        }
        recordingURL = outputFileURL
//        PHPhotoLibrary.requestAuthorization { status in
//            guard status == .authorized else { return }
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
//            }, completionHandler: { (success, error) in
//                if let error = error {
//                    NSLog("error saving video: \(error)")
//                } else {
//                    NSLog("saving video succeeded")
//                }
//            })
//        }
        
        
    }
    
    // MARK: - Private methods
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No Camera Available On Device.")
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documents = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        
        let name = f.string(from: Date())
        return documents.appendingPathComponent(name).appendingPathExtension("mov")
    }
    
    private func updateViews() {
        let isRecording = fileOutput.isRecording
        recordButton.setTitle(isRecording ? "Stop" : "Record", for: [])
    }
    
    //MARK: - Properties
    
    var recordingURL: URL!
    
    
}
