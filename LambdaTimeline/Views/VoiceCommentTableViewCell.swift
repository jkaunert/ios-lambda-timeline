//
//  VoiveCommentTableViewCell.swift
//  LambdaTimeline
//
//  Created by TuneUp Shop  on 2/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

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
    
    private let player = Player()
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    @IBAction func playPauseTapped(_ sender: Any) {
        player.playPause(song: post?.mediaURL)
    }
    func playerDidChangeState(_ player: Player) {
        updateViews()
    }
    
}
