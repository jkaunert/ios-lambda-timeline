//
//  ImagePostDetailTableViewController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/14/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class ImagePostDetailTableViewController: UITableViewController, PlayerDelegate {
    
    func playerDidChangeState(_ player: Player) {
        updateViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.updateViews()
        }
        
    }
    
    func updateViews() {
        
        guard let imageData = imageData,
            let image = UIImage(data: imageData) else {
                print("No Data!")
                return }
        
        title = post?.title
        
        imageView.image = image
        
        titleLabel.text = post.title
        authorLabel.text = post.author.displayName
    }
    
    // MARK: - Table view data source
    private func presentAddTextCommentAlert() {
        // Add Text Comment Alert
        let alert = UIAlertController(title: "Add a comment", message: "Write your comment below:", preferredStyle: .alert)
        
        var commentTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Comment:"
            commentTextField = textField
        }
        
        let addCommentAction = UIAlertAction(title: "Add Comment", style: .default) { (_) in
            
            guard let commentText = commentTextField?.text else { return }
            
            self.postController.addTextComment(with: commentText, to: self.post!)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addCommentAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentChooseCommentTypeAlert() {
        // Choose Comment Type Alert
        let chooseCommentTypeAlert = UIAlertController(title: "Which type of comment do you want to leave?", message: nil, preferredStyle: .alert)
        let addTextCommentAction = UIAlertAction(title: "Add Text Comment", style: .default) { (_) in
            
            self.presentAddTextCommentAlert()
        }
        let addVoiceCommentAction = UIAlertAction(title: "Add Voice Comment", style: .default) { (_) in
            // custom segue for recorder
            self.performSegue(withIdentifier: "AudioRecorderModalVC", sender: self)
            
        }
        let chooseCommentTypeCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        chooseCommentTypeAlert.addAction(addTextCommentAction)
        chooseCommentTypeAlert.addAction(addVoiceCommentAction)
        chooseCommentTypeAlert.addAction(chooseCommentTypeCancelAction)
        
        present(chooseCommentTypeAlert, animated: true, completion: nil)
    }
    
    @IBAction func createComment(_ sender: Any) {
        
        presentChooseCommentTypeAlert()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (post?.comments.count ?? 0) - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = post?.comments[indexPath.row + 1]
    
        if comment?.text != nil {
            print(comment)
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
            // Text Comment Cell
            cell.textLabel?.text = comment?.text
            cell.detailTextLabel?.text = comment?.author.displayName
            return cell
        }else {
            // Audio Comment Cell
            let cell: VoiceCommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VoiceCommentCell", for: indexPath) as! VoiceCommentTableViewCell
            
            print(comment)
            cell.post = post
            cell.comment = comment
            cell.audioStreamURL = comment?.audioURL
            cell.userNameLabel?.text = comment?.author.displayName
            cell.playPauseButton.setTitle(player.isPlaying ? "⏸" : "▶️", for: [])
            return cell
        }
        print(comment?.audioURL!)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AudioRecorderModalVC" {
            let destinationVC = segue.destination as? VoiceCommentRecorderViewController
            destinationVC?.postController = postController
            destinationVC?.post = post
            
        }
    }
    
    var post: Post!
    var postController: PostController!
    var imageData: Data?
    var comment: Comment!
    let player = Player()
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageViewAspectRatioConstraint: NSLayoutConstraint!
}
