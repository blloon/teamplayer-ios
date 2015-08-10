//
//  TeamPlayerEngine.swift
//  TeamSounds
//
//  Created by Said Marouf on 31/07/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import Foundation
import Alamofire

class TeamPlayerEngine {
    
    static let sharedEngine = TeamPlayerEngine()

    let teamID = "blloon"
    
    // MARK: - Tracks
    
    func getTopTracks(completion: (([Track], NSError?) -> Void)?) {
        
        let req = SMTeamPlayerRequest.Songs(teamID: teamID)
        Alamofire.request(req).responseJSON {(request, response, body, error) in
            
            var resultTracks = [Track]()
            
            if let tracks = body as? [[String: AnyObject]] {
                for trackDictionary in tracks {
                    let track = Track.trackFromInfo(trackDictionary)
                    resultTracks.append(track)
                }
            }
            
            if let completion = completion {
                completion(resultTracks, nil)
            }
        }
    }
    
    func getNextTracksAndAdvance(completion: (([Track], NSError?) -> Void)?) {
        
        let req = SMTeamPlayerRequest.Advance(teamID: teamID)
        Alamofire.request(req).responseJSON {(request, response, body, error) in
            
            print(body)
            
            var resultTracks = [Track]()
            
            if let tracks = body as? [[String: AnyObject]] {
                for trackDictionary in tracks {
                    let track = Track.trackFromInfo(trackDictionary)
                    resultTracks.append(track)
                }
            }
            
            if let completion = completion {
                completion(resultTracks, nil)
            }
        }
    }
    
    func addTrack(track: Track, completion: (NSError? -> Void)?) {
        
        let req = SMTeamPlayerRequest.AddSong(teamID: teamID, song: track)
        Alamofire.request(req).responseJSON {(request, response, body, error) in
            print("Body: \(body)")

            if let completion = completion {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(error)
                }
            }
        }
    }
    
    func attemptUpVoteTrack(track: Track, attempts: Int, completion: (([Track], NSError?) -> Void)?) {

        track.upVotes = track.upVotes! + 1
        
        let req = SMTeamPlayerRequest.UpVote(teamID: teamID, song: track)
        Alamofire.request(req).responseJSON {(request, response, body, error) in
            
            var resultTracks = [Track]()
            
            if let tracks = body as? [[String: AnyObject]] {
                for trackDictionary in tracks {
                    let track = Track.trackFromInfo(trackDictionary)
                    resultTracks.append(track)
                }
            }
            
            if let completion = completion {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(resultTracks, error)
                }
            }
        }
    }
    
    func attemptDownVoteTrack(track: Track, attempts: Int, completion: (([Track], NSError?) -> Void)?) {
        
        track.downVotes = track.downVotes! + 1

        let req = SMTeamPlayerRequest.DownVote(teamID: teamID, song: track)
        Alamofire.request(req).responseJSON {(request, response, body, error) in
            
            var resultTracks = [Track]()
            
            if let tracks = body as? [[String: AnyObject]] {
                for trackDictionary in tracks {
                    let track = Track.trackFromInfo(trackDictionary)
                    resultTracks.append(track)
                }
            }
            
            if let completion = completion {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(resultTracks, error)
                }
            }
        }
    }
    
    
    // MARK: - Teams
    
    func createTeam(track: Track, completion: (NSError? -> Void)?) {
        
        let req = SMTeamPlayerRequest.AddSong(teamID: teamID, song: track)
        Alamofire.request(req).responseJSON {(request, response, body, error) in
            print(body)
            if let completion = completion {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(error)
                }
            }
        }
    }
    
}
