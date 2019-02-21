//
//  Comment.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import FirebaseAuth

class Comment: FirebaseConvertible, Equatable {
   
    let text: String?
    let author: Author
    let timestamp: Date
    let audioURL: URL?
    
    static private let textKey = "text"
    static private let authorKey = "author"
    static private let timestampKey = "timestamp"
    static private let audioKey = "audioURL"
    
    init(text: String?, author: Author, timestamp: Date = Date(), audioURL: URL?) {
        self.text = text
        self.author = author
        self.timestamp = timestamp
        self.audioURL = audioURL
        
        
    }
    
    init?(dictionary: [String: Any]) {
        guard let text = dictionary[Comment.textKey] as? String?,
            let authorDictionary = dictionary[Comment.authorKey] as? [String: Any],
            let author = Author(dictionary: authorDictionary),
            let timestampTimeInterval = dictionary[Comment.timestampKey] as? TimeInterval else { return nil }
        self.text = text
        self.author = author
        self.timestamp = Date(timeIntervalSince1970: timestampTimeInterval)
        if let audioURLString = dictionary[Comment.audioKey] as? String {
            self.audioURL = URL(string: audioURLString)
        } else {
            self.audioURL = nil
        }
        
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [Comment.audioKey: audioURL?.absoluteString,
                Comment.textKey: text,
                Comment.authorKey: author.dictionaryRepresentation,
                Comment.timestampKey: timestamp.timeIntervalSince1970]
//    var dictionaryRepresentation: [String: Any] {
//        var dict: [String : Any] = [Comment.authorKey: author.dictionaryRepresentation,
//                Comment.timestampKey: timestamp.timeIntervalSince1970]
//
//        guard let audioURLString = self.audioURL?.absoluteString,
//            let audioURL = URL(string: audioURLString) else { return dict }
//
//        return dict
    }
    
    static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.author == rhs.author &&
            lhs.timestamp == rhs.timestamp
    }
}
