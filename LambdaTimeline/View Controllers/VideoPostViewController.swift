//
//  VideoPostViewController.swift
//  LambdaTimeline
//
//  Created by TuneUp Shop  on 2/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPostViewController: UIViewController {
   ///TestURL
    let testURLString = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
    let testURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(recordingURL)
        imageView.configure(url: "\(recordingURL!)")
        imageView.isLoop = false
        imageView.play()
        
    }
    
    
    //MARK: - Navigation
    
    @IBAction func postButtonTapped(_ sender: Any) {
        imageView.stop()
        //create new video post here
        guard let videoData = try? Data(contentsOf: recordingURL!),
            let title = titleTextField.text, title != "" else {
                presentInformationalAlertController(title: "Uh-oh", message: "Make sure that you add a photo and a caption before posting.")
                return
        }
        
        postController.createPost(with: title, ofType: .video, mediaData: videoData, ratio: 1.0) { (success) in
            guard success else {
                DispatchQueue.main.async {
                    self.presentInformationalAlertController(title: "Error", message: "Unable to create post. Try again.")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: VideoView!
    
    //MARK: - Properties
    var recordingURL: URL!
    var postController: PostController!
    var post: Post?
    var videoData: Data?
    
}
