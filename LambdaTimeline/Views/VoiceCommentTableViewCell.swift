//
//  VoiveCommentTableViewCell.swift
//  LambdaTimeline
//
//  Created by TuneUp Shop  on 2/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class VoiceCommentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBAction func playPauseTapped(_ sender: Any) {
    }
}
