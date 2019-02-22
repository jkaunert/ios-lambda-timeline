//
//  VideoPostCollectionViewCell.swift
//  LambdaTimeline
//
//  Created by TuneUp Shop  on 2/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPostCollectionViewCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLabelBackgroundView()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        videoView.image = nil
        titleLabel.text = ""
        authorLabel.text = ""
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        titleLabel.text = post.title
        authorLabel.text = post.author.displayName
    }
    
    func setupLabelBackgroundView() {
        labelBackgroundView.layer.cornerRadius = 8
        //        labelBackgroundView.layer.borderColor = UIColor.white.cgColor
        //        labelBackgroundView.layer.borderWidth = 0.5
        labelBackgroundView.clipsToBounds = true
    }
    
    func setImage(_ image: UIImage?) {
        videoView.image = image
    }
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var labelBackgroundView: UIView!
}
