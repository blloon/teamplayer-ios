//
//  SCEngine.swift
//  TeamSounds
//
//  Created by Said Marouf on 7/27/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CloudKit



protocol CloudKitDelegate {
    func errorUpdatingModel(error: NSError)
    func modelUpdated()
}


class SCEngine {
    
    static let clientID = "b70434c4f62e23ae73d8c43c0fb5900b"
    static let clientSecret = "eac48da9fe58c1a9fc11b5b5b091151d"
    static let tokenKey = "SoundCloudToken"
    static let codeKey = "SoundCloudCode"
    static let redirectURL = "teamsounds://oauth"

    static let sharedEngine = SCEngine()
    
    
    // MARK: - CloudKit Configs

    //let container : CKContainer
    //let publicDB : CKDatabase
    
    //init() {
        //container = CKContainer(identifier: "iCloud.com.blloon.teamSoundsContainer")
        //publicDB = container.publicCloudDatabase
    //}
    
    func searchForTracks(q: String, completion: (([Track], NSError?) -> Void)?) {
        
        let req = SCRequest.Search(q: q, clientID: SCEngine.clientID, token: SCEngine.token()!)
        Alamofire.request(req).responseJSON {(request, response, body, error) in
        
            print("Body: \(body)")
            
            
            var resultTracks = [Track]()

            if let tracks = body as? [[String: AnyObject]] {
                for trackDictionary in tracks {
                    
//                    var canStream = false
//                    if let streamable = trackDictionary["streamable"] as? Int where streamable == 1 {
//                        canStream = true
//                    }
//                    
//                    if canStream {
//                        let track = Track(trackDictionary["id"] as! NSNumber,
//                            trackDictionary["title"] as? String,
//                            trackDictionary[""] as? String,
//                            trackDictionary["stream_url"] as? String,
//                            trackDictionary["genre"] as? String,
//                            trackDictionary["permalink_url"] as? String,
//                            trackDictionary["artwork_url"] as? String,
//                            canStream)
//                        
//                        
//                        resultTracks.append(track)
//                    }
                    
                    let track = Track.trackFromSoundCloudInfo(trackDictionary)
                    if track.streamable {
                        resultTracks.append(track)
                    }
                }
            }
            
            if let completion = completion {
                completion(resultTracks, nil)
            }
        }
        
    }
    
    
    
    func initiateLogin() -> Bool {
        
        if let token = SCEngine.token() {
            return true
        }
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://soundcloud.com/connect?client_id=\(SCEngine.clientID)&redirect_uri=\(SCEngine.redirectURL)&response_type=code")!)

        return false
    }
    
    func continueLogInWithCode(code: String) -> Bool {
        
        let url = NSURL(string: "https://api.soundcloud.com/oauth2/token/")
        
        let authPostString = "client_id=\(SCEngine.clientID)" +
            "&client_secret=\(SCEngine.clientSecret)" +
            "&grant_type=authorization_code" +
            "&redirect_uri=\(SCEngine.redirectURL)" +
        "&code=\(code)"
        
        
        let postData = authPostString.dataUsingEncoding(NSUTF8StringEncoding)
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("\(postData!.length)", forHTTPHeaderField: "Content-Length")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        let responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        
        if let jsonOutput = NSJSONSerialization.JSONObjectWithData(responseData!, options: nil, error: nil) as? [String: AnyObject] {
            println(jsonOutput)
            
            if let accessTokenString = jsonOutput["access_token"] as? String {
                setToken(accessTokenString)
                
                //Post login notification
                
                NSNotificationCenter.defaultCenter().postNotificationName("SMSoundCloudDidLoginNotification", object: nil)
                
                return true
            }
        }
        
        return false
    }
    
    func isLoggedIn() -> Bool {
        if let token = SCEngine.token() {
            return true
        }
        return false
    }
    
    static func token() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(SCEngine.tokenKey)
    }
    
    private func setToken(token: String) {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: SCEngine.tokenKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
 
    
    
    
    
    // MARK: - CloudKit
    
//    func getAllCloudKitTracks(orderByUpvotes: Bool, completion: (([Track], NSError?) -> Void)?) {
//    
//        let allTracksPredicate = NSPredicate(value: true) //return all
//        let upVotesSorter = NSSortDescriptor(key: "up_votes", ascending: false)
//        let dateSorter = NSSortDescriptor(key: "created_at", ascending: true)
//
//        let allTracksQuery = CKQuery(recordType: "Track", predicate: allTracksPredicate)
//        allTracksQuery.sortDescriptors = orderByUpvotes ? [upVotesSorter] : [dateSorter]
//        
//        publicDB.performQuery(allTracksQuery, inZoneWithID: nil) { results, error in
//            if error != nil {
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.errorUpdatingModel(error)
//                    if let completion = completion {
//                        completion([], error)
//                    }
//                }
//            } else {
//                var fetchedRecords = [Track]()
//                for record in results as! [CKRecord] {
//                    let track = Track(record: record)
//                    fetchedRecords.append(track)
//                }
//
//                dispatch_async(dispatch_get_main_queue()) {
//                    if let completion = completion {
//                        completion(fetchedRecords, error)
//                    }
//                    self.modelUpdated()
//                }
//            }
//        }
//    }
    
//    func attemptUpVoteTrack(track: Track, attempts: Int, completion: (NSError? -> Void)?) {
//        attemptChangeVoteTrack(track, voteBlock: { track in track.upVotes = track.upVotes! + 1}, attempts: attempts, completion: completion)
//    }
//
//    func attemptDownVoteTrack(track: Track, attempts: Int, completion: (NSError? -> Void)?) {
//        attemptChangeVoteTrack(track, voteBlock: { track in track.downVotes = track.downVotes! + 1}, attempts: attempts, completion: completion)
//    }
    
//    func attemptChangeVoteTrack(track: Track, voteBlock: (Track -> Void), attempts: Int, completion: (NSError? -> Void)?) {
//
//        voteBlock(track)
//        
//        let upvoteOperation = CKModifyRecordsOperation()
//        upvoteOperation.recordsToSave = [track.record]
//        upvoteOperation.savePolicy = .IfServerRecordUnchanged
//        upvoteOperation.perRecordCompletionBlock = { record, error in
//        
//            if error != nil {
//                //have a conflict?
//                if let errorDict = error.userInfo as? [String: AnyObject] {
//                    if let serverRecordCopy = errorDict[CKRecordChangedErrorServerRecordKey] as? CKRecord {
//                        print("server copy: \(serverRecordCopy)")
//                        
//                        let serverTrack = Track(record: serverRecordCopy)
//                        voteBlock(serverTrack)
//                        
//                        if attempts < 3 {
//                            self.attemptChangeVoteTrack(serverTrack, voteBlock: voteBlock, attempts:attempts + 1, completion: completion)
//                        }
//                    }
//                }
//                
//                if let completion = completion {
//                    dispatch_async(dispatch_get_main_queue()) {
//                        completion(error)
//                    }
//                }
//            }
//            else {
//                let serverTrack = Track(record: record)
//                print("Updated Upvotes!!  \(serverTrack.upVotes)")
//                if let completion = completion {
//                    dispatch_async(dispatch_get_main_queue()) {
//                        completion(error)
//                    }
//                }
//            }
//        }
//        
//        publicDB.addOperation(upvoteOperation)
//    }
    
    
    
//    func addTrack(track: Track, completion: (NSError? -> Void)?) {
//
//        publicDB.saveRecord(track.recordFromTrack(), completionHandler: { (record, error) -> Void in
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                
//                if error != nil {
//                    println("ERRRRRRR \(error.debugDescription)")
//                    
//                    let alert = UIAlertController(title: nil, message: "\(error.debugDescription)", preferredStyle: UIAlertControllerStyle.Alert)
//                    let a = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
//                        
//                    })
//                    alert.addAction(a)
//
//                    if let vc  = UIApplication.sharedApplication().keyWindow?.rootViewController {
//                        vc.presentViewController(alert, animated: true, completion: { () -> Void in
//                        
//                        })
//                    }
//
//                }
//                
//                if record != nil {
//                    let v = record.objectForKey("name")
//                    println("-------- \(v)")
//                    
//                    let alert = UIAlertController(title: nil, message: "\(v)", preferredStyle: UIAlertControllerStyle.Alert)
//                    let a = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
//                        
//                    })
//                    alert.addAction(a)
//                    
//                    if let vc  = UIApplication.sharedApplication().keyWindow?.rootViewController {
//                        vc.presentViewController(alert, animated: true, completion: { () -> Void in
//                            
//                        })
//                    }
//                }
//                
//                //
//                
//            }
//            
//            if let completion = completion {
//                dispatch_async(dispatch_get_main_queue()) {
//                    completion(error)
//                }
//            }
//        })
//    }
    
}


//extension SCEngine: CloudKitDelegate {
//
//    func errorUpdatingModel(error: NSError) {
//        print("errorUpdatingModel: \(error)")
//    }
//    
//    func modelUpdated() {
//        print("Model Updated!!!")
//    }
//
//}
//
