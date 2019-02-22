//
//  PostController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//
import UIKit
import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import AVFoundation

enum CommentMediaType: String {
    case text
    case audio
}

class PostController {
    
    
    func createPost(with title: String, ofType mediaType: MediaType, mediaData: Data, ratio: CGFloat? = nil, completion: @escaping (Bool) -> Void = { _ in }) {
        
        guard let currentUser = Auth.auth().currentUser,
            let author = Author(user: currentUser) else { return }
        
        store(mediaData: mediaData, mediaType: mediaType) { (mediaURL) in
            
            guard let mediaURL = mediaURL else { completion(false); return }
            
            let imagePost = Post(title: title, mediaURL: mediaURL, mediaType: mediaType, ratio: ratio, author: author)
            
            self.postsRef.childByAutoId().setValue(imagePost.dictionaryRepresentation) { (error, ref) in
                if let error = error {
                    NSLog("Error posting image post: \(error)")
                    completion(false)
                }
        
                completion(true)
            }
        }
    }
    
    func addTextComment(with text: String, to post: Post) {
        
        guard let currentUser = Auth.auth().currentUser,
            let author = Author(user: currentUser) else { return }
        
        let comment = Comment(text: text, author: author, audioURL: nil)
        post.comments.append(comment)
        
        savePostToFirebase(post)
    }
    
    func addAudioComment(with audioData: AVAudioFile, ofType mediaType: MediaType, to post: Post, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let currentUser = Auth.auth().currentUser,
            let author = Author(user: currentUser) else { return }
            let songData = try! Data(contentsOf: audioData.url)
        
        store(mediaData: songData, mediaType: mediaType) { (mediaURL) in
            
           
            guard let mediaURL = mediaURL else { completion(false); return }
            
            let audioComment = Comment(text: nil, author: author, audioURL: mediaURL)
            post.comments.append(audioComment)
            
            self.savePostToFirebase(post) { (error) in
                if let error = error {
                    NSLog("Error posting audio comment: \(error)")
                    completion(false)
                }
                
                completion(true)
            }
        }
    }
 
    func observePosts(completion: @escaping (Error?) -> Void) {
        
        postsRef.observe(.value, with: { (snapshot) in
            
            guard let postDictionaries = snapshot.value as? [String: [String: Any]] else { return }
            
            var posts: [Post] = []
            
            for (key, value) in postDictionaries {
                
                guard let post = Post(dictionary: value, id: key) else { continue }
                
                posts.append(post)
            }
            
            self.posts = posts.sorted(by: { $0.timestamp > $1.timestamp })
            
            completion(nil)
            
        }) { (error) in
            NSLog("Error fetching posts: \(error)")
        }
    }
    
    func savePostToFirebase(_ post: Post, completion: (Error?) -> Void = { _ in }) {
        
        guard let postID = post.id else { return }
        
        let ref = postsRef.child(postID)
        
        ref.setValue(post.dictionaryRepresentation)
    }

    private func store<T>(mediaData: T, mediaType: MediaType, completion: @escaping (URL?) -> Void) {
        
        let mediaID = UUID().uuidString
        let mediaRef: StorageReference
        let metadata = StorageMetadata()
        
        switch mediaType {
            
        case .image:
             mediaRef = storageRef.child(mediaType.rawValue).child(mediaID)
             let uploadTask = mediaRef.putData(mediaData as! Data, metadata: nil) { (metadata, error) in
                if let error = error {
                    NSLog("Error storing media data: \(error)")
                    completion(nil)
                    return
                }
                
                if metadata == nil {
                    NSLog("No metadata returned from upload task.")
                    completion(nil)
                    return
                }
                
                mediaRef.downloadURL(completion: { (url, error) in
                    
                    if let error = error {
                        NSLog("Error getting download url of media: \(error)")
                    }
                    
                    guard let url = url else {
                        NSLog("Download url is nil. Unable to create a Media object")
                        
                        completion(nil)
                        return
                    }
                    completion(url)
                })
            }
            uploadTask.resume()
        case .audio:
            mediaRef = storageRef.child(mediaType.rawValue).child(mediaID)
            metadata.contentType = "audio/wav"
            
            let uploadTask = mediaRef.putData(mediaData as! Data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    NSLog("Error storing media data: \(error)")
                    completion(nil)
                    return
                }
                
                if metadata == nil {
                    NSLog("No metadata returned from upload task.")
                    completion(nil)
                    return
                }
                
                mediaRef.downloadURL(completion: { (url, error) in
                    
                    if let error = error {
                        NSLog("Error getting download url of media: \(error)")
                    }
                    
                    guard let url = url else {
                        NSLog("Download url is nil. Unable to create a Media object")
                        
                        completion(nil)
                        return
                    }
                    print(url)
                    completion(url)
                })
            }
            uploadTask.resume()
        case .video:
            mediaRef = storageRef.child(mediaType.rawValue).child(mediaID)
            metadata.contentType = "video/mov"
            
            let uploadTask = mediaRef.putData(mediaData as! Data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    NSLog("Error storing media data: \(error)")
                    completion(nil)
                    return
                }
                
                if metadata == nil {
                    NSLog("No metadata returned from upload task.")
                    completion(nil)
                    return
                }
                
                mediaRef.downloadURL(completion: { (url, error) in
                    
                    if let error = error {
                        NSLog("Error getting download url of media: \(error)")
                    }
                    
                    guard let url = url else {
                        NSLog("Download url is nil. Unable to create a Media object")
                        
                        completion(nil)
                        return
                    }
                    print(url)
                    completion(url)
                })
            }
            uploadTask.resume()
        }
    }
    
    var posts: [Post] = []
    let currentUser = Auth.auth().currentUser
    let postsRef = Database.database().reference().child("posts")
    
    let storageRef = Storage.storage().reference()
    
    
}
