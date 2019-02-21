//
//  VoiveCommentTableViewCell.swift
//  LambdaTimeline
//
//  Created by TuneUp Shop  on 2/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceCommentTableViewCell: UITableViewCell, PlayerDelegate, UITableViewDelegate {
    

    override func prepareForReuse() {
        super.prepareForReuse()
        
        userNameLabel.text = ""
        playPauseButton.setTitle("", for: [])
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        let isPlaying = player.isPlaying
        playPauseButton.setTitle(isPlaying ? "⏸" : "▶️", for: [])
        userNameLabel.text = post.author.displayName
        
    }
    
    var post: Post? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    let player = Player()
    

    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var aVPlayer: AVPlayer!
    var currentTime: CMTime = CMTime.zero

    
    @IBAction func playPauseTapped(_ sender: Any) {
        
        let audiourl = audioStreamURL
        let playerItem: AVPlayerItem = AVPlayerItem(url: audiourl!)
        aVPlayer = AVPlayer(playerItem: playerItem)
        if playPauseButton.title(for: []) == "▶️" {
            
            aVPlayer.seek(to: currentTime)
            print(currentTime)
            aVPlayer.play()
            
            playPauseButton.setTitle("⏸", for: [])
        }else if playPauseButton.title(for: []) == "⏸" {
            aVPlayer.pause()
            currentTime = aVPlayer.currentTime()
            playPauseButton.setTitle("▶️", for: [])
        }
  
    }
    func playerDidChangeState(_ player: Player) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    var audioStreamURL: URL!
    var comment: Comment!
    

}
