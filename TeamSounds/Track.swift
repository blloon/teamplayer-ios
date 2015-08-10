//
//  Track.swift
//  TeamSounds
//
//  Created by Said Marouf on 31/07/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import Foundation

class Track {
    
    var id: NSNumber!
    var title: String?
    var author: String?
    var streamURLString: String?
    var webURLString: String?
    var coverURLString: String?
    //var genre: String?
    var createdAt: NSDate?
    var streamable: Bool = false

    var score: Int? = 0
    var upVotes: Int? = 0
    var downVotes: Int? = 0
    
    func streamURL(token: String) -> NSURL? {
        if let urlString = streamURLString {
            return NSURL(string: "\(urlString)?client_id=\(SCEngine.clientID)")
        }
        return nil
    }
    
    func streamURL() -> NSURL? {
        if let urlString = streamURLString {
            return NSURL(string: "\(urlString)?client_id=\(SCEngine.clientID)")
        }
        return nil
    }
    
    static func trackFromInfo(trackDictionary: [String: AnyObject?]) -> Track {
        
        let track = Track()
        track.id = trackDictionary["id"] as! NSNumber
        track.title = trackDictionary["title"] as? String
        track.streamURLString = trackDictionary["stream_url"] as? String
        track.webURLString = trackDictionary["url"] as? String
        track.coverURLString = trackDictionary["artwork_url"] as? String
        track.upVotes = trackDictionary["upvotes_count"] as? Int
        track.downVotes = trackDictionary["downvotes_count"] as? Int
        track.score = trackDictionary["score"] as? Int
        if let streamable = trackDictionary["streamable"] as? Int where streamable == 1 {
            track.streamable = true
        }
        
        return track
    }
    
    static func trackFromSoundCloudInfo(trackDictionary: [String: AnyObject?]) -> Track {
        
        let track = Track()
        track.id = trackDictionary["id"] as! NSNumber
        track.title = trackDictionary["title"] as? String
        track.streamURLString = trackDictionary["stream_url"] as? String
        track.webURLString = trackDictionary["permalink_url"] as? String
        track.coverURLString = trackDictionary["artwork_url"] as? String
        track.streamable = trackDictionary["streamable"] as! Bool
        
        return track
    }
    
    
//    init(id: NSNumber!, name name: String?, author author: String?, streamURLString streamURLString: String?, genre genre: String?, webURLString webURLString: String?, coverURLString coverURLString: String?, streamable streamable: Bool, score score: Int?) {
//        self.id = id
//        self.name = name;
//        self.author = author
//        self.streamURLString = streamURLString
//        self.genre = genre
//        self.streamable = streamable
//        self.webURLString = webURLString
//        self.coverURLString = coverURLString
//    }
    
//    init(_ id: NSNumber!, _ name: String?, _ author: String?, _ streamURLString: String?, _ webURLString: String?, _ genre: String?, _ upVotes: Int? = 0, _ downVotes: Int? = 0) {
//        self.id = id
//        self.name = name;
//        self.author = author
//        self.streamURLString = streamURLString
//        self.webURLString = webURLString
//        self.genre = genre
//        self.upVotes = upVotes
//        self.downVotes = downVotes
//    }
}