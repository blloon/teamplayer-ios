//
//  SMTeamPlayerRequest.swift
//  TeamSounds
//
//  Created by Said Marouf on 31/07/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import Foundation
import Alamofire

enum SMTeamPlayerRequest: URLRequestConvertible {
    
    // MARK: Config
    private static let baseURLString = "http://teamplayer-staging.herokuapp.com/api"
    
    
    // MARK: APIs
    case Songs(teamID: String)
    case UpcomingSongs(teamID: String)
    case AddSong(teamID: String, song: Track)
    case UpVote(teamID: String, song: Track)
    case DownVote(teamID: String, song: Track)
    case Advance(teamID: String)
    
    private var method: Alamofire.Method {
        switch self {
        case .Songs, .UpcomingSongs:
            return .GET
        case .AddSong:
            return .POST
        case .UpVote, .DownVote, .Advance:
            return .POST
        }
    }
    
    private var path: String {
        switch self {
        case .Songs(let teamID):
            return "/teams/\(teamID)/songs"
        case .UpcomingSongs(let teamID):
            return "/teams/\(teamID)/songs"
        case .UpcomingSongs(let teamID):
            return "/teams/\(teamID)/songs"
        case .AddSong(let teamID, let song):
            return "/teams/\(teamID)/songs"
        case .UpVote(let teamID, let song):
            return "/teams/\(teamID)/songs/\(song.id)/upvotes"
        case .DownVote(let teamID, let song):
            return "/teams/\(teamID)/songs/\(song.id)/downvotes"
        case .Advance(let teamID):
            return "/teams/\(teamID)/songs/advance"
        }
    }

    var URLRequest: NSURLRequest {
        
        let URL = NSURL(string: SMTeamPlayerRequest.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
            
        case .Songs(let teamID):
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        case .UpcomingSongs(let teamID):
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        case .AddSong(let teamID, let song):
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["url" : song.webURLString!]).0
        case .UpVote(let teamID, let song):
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["team_id": teamID, "song_id": song.id]).0
        case .DownVote(let teamID, let song):
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["team_id": teamID, "song_id": song.id]).0
        case .Advance(let teamID):
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
            
        default:
            println("path: \(URL.URLByAppendingPathComponent(path))")
            return mutableURLRequest
        }
    }
}