//
//  VoiceCommentRecorderViewController.swift
//  LambdaTimeline
//
//  Created by TuneUp Shop  on 2/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class VoiceCommentRecorderViewController: UIViewController, PlayerDelegate, RecorderDelegate {
    func playerDidChangeState(_ player: Player) {
        updateViews()
    }
    
    func recorderDidChangeState(_ recorder: Recorder) {
        updateViews()
    }
    
    private func updateViews() {
        let isPlaying = player.isPlaying
        recorderPlayPauseButton.setTitle(isPlaying ? "⏸" : "▶️", for: [])
        
        let isRecording = recorder.isRecording
        recorderRecordButton.setTitle(isRecording ? "⏹" : "⏺", for: [])
        
        let remainingTime = player.timeRemaining
        let elapsedTime = player.elapsedTime
        
        elapsedTimeLabel.text = timeFormatter.string(from: elapsedTime)
        remainingTimeLabel.text = timeFormatter.string(from: remainingTime)
        
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(player.totalDuration)
        timeSlider.value = Float(player.elapsedTime)
    }
    

    private let player = Player()
    private let recorder = Recorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        player.delegate = self
        recorder.delegate = self
        let fontSize = UIFont.systemFontSize
        let font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
        elapsedTimeLabel.font = font
        remainingTimeLabel.font = font
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    @IBOutlet weak var recorderPlayPauseButton: UIButton!
    @IBAction func recorderPlayPauseButtonTapped(_ sender: Any) {
        print("recorderPlayPauseButton tapped")
        player.playPause(song: recorder.currentFile)
    }
    
    @IBOutlet weak var recorderRecordButton: UIButton!
    @IBAction func recorderRecordButtonTapped(_ sender: Any) {
        print("recorderRecordButton tapped")
        recorder.toggleRecording()
    }
    
    @IBAction func cancelAddAudioComment(_ sender: Any) {
        
    }
    
    @IBAction func postAudioComment(_ sender: Any) {
        
    }
    
    private lazy var timeFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .positional
        f.zeroFormattingBehavior = .pad
        f.allowedUnits = [.minute, .second]
        return f
    }()
    
}
