//
//  ViewController.swift
//  TeamSoundsPlayer
//
//  Created by Said Marouf on 7/29/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.backgroundColor = UIApplication.sharedApplication().windows[0].tintColor //bad
            playPauseButton.layer.cornerRadius = floor(CGRectGetHeight(playPauseButton.bounds) / 2.0)
            playPauseButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var orderSwitch: UISwitch!
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var nextPlayingLabel: UILabel!
    
    var audioPlayer: AVPlayer?
    var playingItem: AVPlayerItem?
    
    //var playingIndex = 0
    var playOrderByUpvotes = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didLoginToSoundCloud:", name: "SMSoundCloudDidLoginNotification", object: nil)
        
        if SCEngine.sharedEngine.isLoggedIn() {
            loginButton.hidden = true
            loginButton.enabled = false
        }
        
        self.nowPlayingLabel.text = "Add tracks to start playing!"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        playOrderByUpvotes = orderSwitch.on

        if !SCEngine.sharedEngine.isLoggedIn() {
            //always make sure we are logged in
            attemptLogin()
            playPauseButton.hidden = true
            playPauseButton.enabled = false
        }
        else {
            
            if let player = audioPlayer where player.rate > 0 {
                //playing...
            }
            else {
                getTracksAndTryPlaying()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func itemFinishedPlaying(notification: NSNotification) {
        
        if let item = notification.object as? AVPlayerItem {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
        }
        
        //try next...
        
        getTracksAndTryPlaying()

    }
    
    
    @IBAction func playPause() {
        
        if let player = audioPlayer {
            
            if player.rate > 0 { //playing
                player.pause()
                playPauseButton.setTitle("Play", forState: UIControlState.Normal)
            }
            else {
                player.play()
                playPauseButton.setTitle("Pause", forState: UIControlState.Normal)
            }
        }
    }
    
    
    func getTracksAndTryPlaying() {
        
        if !SCEngine.sharedEngine.isLoggedIn() {
            orderSwitch.enabled = true
            playPauseButton.enabled = true
            return
        }
        
        TeamPlayerEngine.sharedEngine.getNextTracksAndAdvance { (tracks, error) -> Void in

            println("tracks:   \(tracks.map { $0.title })")
            
            if tracks.count > 0 {
                
                var targetTrack: Track?
                var foundStreamAble = false
                
                var trackIndex = 0 //try to play forst song always.
                
                while trackIndex < tracks.count && targetTrack == nil {
                    let track = tracks[trackIndex]
                    if track.streamURL() != nil {
                        targetTrack = track
                    }
                    trackIndex++
                }
                
                if trackIndex < tracks.count {
                    let nextTrack = tracks[trackIndex]
                    self.nextPlayingLabel.text = "Next: \(nextTrack.title!)"
                }
                else {
                    self.nextPlayingLabel.text = "Nothing to play next :("
                }
                
                //go back to first if we fail...
                //this is not good enough. we should just fail actually..
                if targetTrack == nil {
                    targetTrack = tracks[0]
                }
                
                
                if let targetTrack = targetTrack {
                    //should be more careful...
                    if let streamUrl = targetTrack.streamURL() { //wrong to do this. should be fine for now..
                        
                        println(">> \(streamUrl.absoluteString)")
                        
                        if let trackName = targetTrack.title {
                            self.nowPlayingLabel.text = "Now Playing: \(trackName)"
                        }
                        
                        if let player = self.audioPlayer {
                            player.removeObserver(self, forKeyPath: "status")
                        }
                        
                        let asset = AVURLAsset(URL:streamUrl, options:nil)
                        self.playingItem = AVPlayerItem(asset: asset)
                        self.audioPlayer = AVPlayer(playerItem: self.playingItem)
                        self.audioPlayer?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New , context: nil)
                        
                        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemFinishedPlaying:", name:AVPlayerItemDidPlayToEndTimeNotification, object: self.playingItem)
                    }
                    else {
                        println("No streamable tracks found!!!!!!")
                    }
                }
                else {
                    println("No streamable tracks found!!!!!!")
                }
            }
            
            self.orderSwitch.enabled = true
            self.playPauseButton.enabled = true   
        }
    }
    
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {

        if let player = object as? AVPlayer {
            if player === self.audioPlayer && keyPath == "status" {

                switch player.status {
                case AVPlayerStatus.ReadyToPlay:
                    player.play()
                    playPauseButton.setTitle("Pause", forState: UIControlState.Normal)
                case AVPlayerStatus.Failed:
                    player.pause()
                    playPauseButton.setTitle("Play", forState: UIControlState.Normal)
                default:
                    break
                }
            }
        }
    }
    
//    @IBAction func playOrderChanged() {
//        
//        let isOn = orderSwitch.on
//        playOrderByUpvotes = isOn
//        
//        if let player = self.audioPlayer {
//            if player.rate > 0 {
//                player.pause()
//                playPauseButton.setTitle("Play", forState: UIControlState.Normal)
//            }
//        }
//        
//        playPauseButton.enabled = false
//        orderSwitch.enabled = false
//        
//        //reset playing index. 
//        //We are playing the list in a totally different order now
//        
//        self.playingIndex = 0
//        getTracksAndTryPlaying()
//        
//        println("playOrderByUpvotes: \(playOrderByUpvotes)")
//    }
//    
    
    @IBAction func attemptLogin() {
        if SCEngine.sharedEngine.isLoggedIn() {
            
        }
        else {
            SCEngine.sharedEngine.initiateLogin()
        }
    }
    
    func didLoginToSoundCloud(notification: NSNotification) {
        if SCEngine.sharedEngine.isLoggedIn() {
            
            loginButton.hidden = true
            loginButton.enabled = false

            getTracksAndTryPlaying()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

