//
//  VoiveCommentTableViewCell.swift
//  LambdaTimeline
//
//  Created by TuneUp Shop  on 2/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceCommentTableViewCell: UITableViewCell, PlayerDelegate {

    
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
            updateViews()
        }
    }
    
    let player = Player()
    

    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var aVPlayer: AVPlayer!
    
    
    @IBAction func playPauseTapped(_ sender: Any) {
        let audiourl = URL(string: "https://firebasestorage.googleapis.com/v0/b/my-awesome-project-id-5bed7.appspot.com/o/audio%2F5DCF6009-39EA-49A8-B6EC-A1AD87CFC8B5?alt=media&token=e34889b1-45e9-485c-ae20-23e5e89d0e18")
        let playerItem: AVPlayerItem = AVPlayerItem(url: audiourl!)
        aVPlayer = AVPlayer(playerItem: playerItem)
        aVPlayer.play()
        
//        player.playPause(song: URL(string: "https://firebasestorage.googleapis.com/v0/b/my-awesome-project-id-5bed7.appspot.com/o/audio%2F5DCF6009-39EA-49A8-B6EC-A1AD87CFC8B5?alt=media&token=e34889b1-45e9-485c-ae20-23e5e89d0e18"))
//        let isPlaying = player.isPlaying
//        playPauseButton.setTitle(isPlaying ? "⏸" : "▶️", for: [])
    }
    func playerDidChangeState(_ player: Player) {
        updateViews()
    }
    
    var audioStreamURL: URL?

}
