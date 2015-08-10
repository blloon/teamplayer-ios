//
//  SecondViewController.swift
//  TeamSounds
//
//  Created by Said Marouf on 7/27/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import UIKit

class TopRatedViewController: UITableViewController {

    private var fetchingTracksInProgress: Bool = false
    private var tracks: [Track] = []
    private var didInitialRequest = false
    private var prototypeCell: VoteCell?
    
    private var refreshTimer: NSTimer?
    private let refreshRate = 30.0 //seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top Tracks"
        
        self.refreshControl = UIRefreshControl(frame: CGRectMake(0, 0, 24, 24))
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !didInitialRequest {
            self.refreshControl?.beginRefreshing()
            self.tableView.setContentOffset(CGPointMake(0, -10), animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didInitialRequest {
            getTopTracks()
            
            refreshTimer = NSTimer.scheduledTimerWithTimeInterval(refreshRate, target: self, selector: "refresh", userInfo: nil, repeats: true)
        }
    }
    
    func refresh() {
        getTopTracks()
    }
    
    func getTopTracks() {
        
        if fetchingTracksInProgress {
            return
        }
        
        fetchingTracksInProgress = true

        TeamPlayerEngine.sharedEngine.getTopTracks { (tracks, error) -> Void in
            self.tracks.removeAll(keepCapacity: true)
            self.tracks = self.tracks + tracks

            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()

            self.fetchingTracksInProgress = false
            self.didInitialRequest = true

            if self.tracks.count > 0 {
                self.title = "Top Tracks (\(self.tracks.count))"
            }
            else {
                self.title = "No Tracks!"
            }
        }
    }
    
    func stopRefreshTimer() {
        refreshTimer?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        stopRefreshTimer()
    }
}


private typealias DataSource = UITableViewDataSource
extension TopRatedViewController: DataSource {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("voteCell", forIndexPath: indexPath) as! VoteCell
        cell.detailTextLabel?.textColor = UIColor(white: 0.8, alpha: 1.0)
        
        var trackName = "Track"
        var trackUpVotes = "↑0"
        var trackDownVotes = "↓0"
        if let name = tracks[indexPath.row].title {
            trackName = name
        }
        if let upvotes = tracks[indexPath.row].upVotes {
            trackUpVotes = "↑\(upvotes)"
        }
        if let downvotes = tracks[indexPath.row].downVotes {
            trackDownVotes = "↓\(downvotes)"
        }

        cell.configureCell(trackName, upVotes: trackUpVotes, downVotes: trackDownVotes)
        
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if self.prototypeCell == nil {
            self.prototypeCell = tableView.dequeueReusableCellWithIdentifier("voteCell") as? VoteCell
        }

        if let pCell = self.prototypeCell {
            var trackName = "Track"
            var trackUpVotes = "↑0"
            var trackDownVotes = "↓0"
            if let name = tracks[indexPath.row].title {
                trackName = name
            }
            if let upvotes = tracks[indexPath.row].upVotes {
                trackUpVotes = "↑\(upvotes)"
            }
            if let downvotes = tracks[indexPath.row].downVotes {
                trackDownVotes = "↓\(downvotes)"
            }
            
            pCell.configureCell(trackName, upVotes: trackUpVotes, downVotes: trackDownVotes)

            pCell.bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.bounds), 9999);
            
            pCell.setNeedsLayout()
            pCell.layoutIfNeeded()
          
            
            let size = pCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            
            return size.height + 1
        }
        
        return 64
    }
}

private typealias Delegate = UITableViewDelegate
extension TopRatedViewController: Delegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //ask to upvote or not...

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let track = self.tracks[indexPath.row]
        
        var message: String = "Yay, or Nay?"
        if let trackName = track.title {
            message = "Yay, or Nay?\nTrack: \(trackName)"
        }
        let alertController = UIAlertController(title: nil, message: message , preferredStyle: UIAlertControllerStyle.ActionSheet)

        alertController.addAction(UIAlertAction(title: "↑ Upvote", style: UIAlertActionStyle.Default, handler: { action in
            TeamPlayerEngine.sharedEngine.attemptUpVoteTrack(track, attempts: 0) { tracks, error in
                print("---- \(error)")
                self.tracks.removeAll(keepCapacity: true)
                self.tracks = self.tracks + tracks
                
                self.tableView.reloadData()

            
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        
        alertController.addAction(UIAlertAction(title: "↓ Downvote", style: UIAlertActionStyle.Default, handler: { action in
            TeamPlayerEngine.sharedEngine.attemptDownVoteTrack(track, attempts: 0) { tracks, error in
                print("---- \(error)")
                self.tracks.removeAll(keepCapacity: true)
                self.tracks = self.tracks + tracks
                
                self.tableView.reloadData()

            }
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
}

//Player.. gets proppular... plays first...after finished... get list gain... play first...
