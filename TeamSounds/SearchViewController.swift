//
//  FirstViewController.swift
//  TeamSounds
//
//  Created by Said Marouf on 7/27/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import UIKit

public class SearchViewController: UITableViewController {

    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet public weak var searchBar: UISearchBar!
    
    private var searchInProgress = false
    private var searchREesults: [Track] = []
    private var didInitialRequest = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        if SCEngine.sharedEngine.isLoggedIn() {
            loginButton.title = "Log out"
        }
        else {
            loginButton.title = "Log in"
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didLoginToSoundCloud:", name: "SMSoundCloudDidLoginNotification", object: nil)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
        if !didInitialRequest {
            doSearch("Taylor Swift")
        }
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Search
    
    func doSearch(q: String) {
        if searchInProgress {
            return
        }
        
        if SCEngine.sharedEngine.isLoggedIn() {
            searchInProgress = true
            SCEngine.sharedEngine.searchForTracks(q, completion: { (tracks, error) -> Void in
                //println("Tracks: \(tracks)")
                //println("Error: \(error)")
                
                self.searchREesults = tracks
                self.tableView.reloadData()
                
                self.searchInProgress = false
                self.didInitialRequest = true
            })
        }
    }
    
    @IBAction func didSubmitSearchTerm() {
        
        //doSearch("Taylor Swift")
    }
    
    
    // MARK: - Authentication
    
    @IBAction func attemptLogin() {
        if SCEngine.sharedEngine.isLoggedIn() {
            //Logout...
            
            
            
        }
        else {
            SCEngine.sharedEngine.initiateLogin()
        }
    }
    
    func didLoginToSoundCloud(notification: NSNotification) {
        if SCEngine.sharedEngine.isLoggedIn() {
            loginButton.title = "Log Out"
            
            // do stuff...
        }
    }

    public override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

private typealias DataSource = UITableViewDataSource
extension SearchViewController: DataSource {
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! AddTrackCell
        cell.detailTextLabel?.textColor = UIColor(white: 0.8, alpha: 1.0)
        
        var trackName = "Track"
        var trackGenre = "unknown"
        var coverURLString: String?
        
        if let name = searchREesults[indexPath.row].title {
            trackName = name
        }
        //if let genre = searchREesults[indexPath.row].genre {
        //    trackGenre = genre
        //}
        if let coverURL = searchREesults[indexPath.row].coverURLString {
            coverURLString = coverURL
        }
        cell.configureCell(trackName, content: trackGenre, coverURLString: coverURLString)
        
        cell.contentView.bounds = CGRect(x: 0.0, y: 0.0, width: 99999.0, height: 99999.0)

        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchREesults.count
    }
}

private typealias Delegate = UITableViewDelegate
extension SearchViewController: Delegate {
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //ask to upvote or not...
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let track = self.searchREesults[indexPath.row]
        
        let alertController = UIAlertController(title: nil, message: "\(track.title!)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Add to Team Playlist", style: UIAlertActionStyle.Default, handler: { action in
            
            TeamPlayerEngine.sharedEngine.addTrack(track) {error in
                if error != nil {
                    println("Track already exits aybe.. \(error)")
                }
            
            
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        
        self.presentViewController(alertController, animated: true) {
        }
    }
}

private typealias SearchDelegate = UISearchBarDelegate
extension SearchViewController: SearchDelegate {
    
    public func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text != nil && count(searchBar.text) > 0 {
            searchBar.resignFirstResponder()
            
            doSearch(searchBar.text)
        }
    }
}