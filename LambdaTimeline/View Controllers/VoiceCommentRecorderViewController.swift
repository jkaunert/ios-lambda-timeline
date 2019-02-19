//
//  VoiceCommentRecorderViewController.swift
//  LambdaTimeline
//
//  Created by TuneUp Shop  on 2/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class VoiceCommentRecorderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var recorderPlayPauseButton: UIButton!
    @IBAction func recorderPlayPauseButtonTapped(_ sender: Any) {
        print("recorderPlayPauseButton tapped")
    }
    
    @IBOutlet weak var recorderRecordButton: UIButton!
    @IBAction func recorderRecordButtonTapped(_ sender: Any) {
        print("recorderRecordButton tapped")
    }
    
}
