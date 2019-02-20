//
//  ImagePostDetailTableViewController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/14/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class ImagePostDetailTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        
        guard let imageData = imageData,
            let image = UIImage(data: imageData) else { return }
        
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
            
            self.postController.addTextComment(with: commentText, to: &self.post!)
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        
        let comment = post?.comments[indexPath.row + 1]
        
        cell.textLabel?.text = comment?.text
        cell.detailTextLabel?.text = comment?.author.displayName
        
        return cell
    }
    
    var post: Post!
    var postController: PostController!
    var imageData: Data?
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageViewAspectRatioConstraint: NSLayoutConstraint!
}
