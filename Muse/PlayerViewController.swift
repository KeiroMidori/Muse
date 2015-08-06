//
//  PlayerViewController.swift
//  Muse
//
//  Created by Sacha BECOURT on 7/30/15.
//  Copyright (c) 2015 SB. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class PlayerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVAudioPlayerDelegate {

    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var soundButton: UIButton!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var trackArtistLabel: UILabel!
    @IBOutlet var trackTitleLabel: UILabel!
    @IBOutlet var trackQueueCollectionView: UICollectionView!
    var radio: Radio?
    var trackListArray = NSMutableArray(capacity: 0)
    var loaderImageView: AnimatedLoaderImageView?
    var player = AVPlayer()
    var shouldShowPlayer: Bool = false
    var playerShouldShowTrackWithURL: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        trackQueueCollectionView.delegate = self
        trackQueueCollectionView.dataSource = self

        volumeSlider.setThumbImage(UIImage(named: "diamond"), forState: UIControlState.Normal)
        if radio != nil {
            getTrackList(radio!.radioID)
        }
        loaderImageView = AnimatedLoaderImageView(frame: CGRectMake(self.view.center.x - 75, self.view.center.y - 75, 150, 150))
        self.view.addSubview(loaderImageView!)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Misc Tools
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    // MARK: Audio Management
    
    func trackEnd() {
        for cell in trackQueueCollectionView.visibleCells() {
            var indexPath = trackQueueCollectionView.indexPathForCell(cell as! UICollectionViewCell)
            if ((indexPath!.row + 1) < trackListArray.count) {
                let newIndexPath = NSIndexPath(forRow: indexPath!.row + 1, inSection: indexPath!.section)
                trackQueueCollectionView.selectItemAtIndexPath(newIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
                updateUIWithTrack(newIndexPath.row)
            }
        }
    }
    
    func playTrackWithID(trackID: Int) {
        if (trackListArray.count != 0) {
            let track = trackListArray.objectAtIndex(trackID) as! Track
            let length = secondsToHoursMinutesSeconds(track.trackLength)
            var minutes = "\(length.1)"
            var seconds = "\(length.2)"
            if length.1 < 10 {
                minutes = "0\(length.1)"
            }
            if length.2 < 10 {
                seconds = "0\(length.2)"
            }
            timerLabel.text = "\(minutes):\(seconds)"
            playPauseButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            AudioPlayerManager.sharedInstance.playWithTrack(track)
        }
    }

    // MARK: Data Fetch and Management methods
    
    func createTrackListWithJson(json: AnyObject) {
        let trackListTmp = json.valueForKey("retour") as! NSDictionary
        let trackList = trackListTmp.valueForKey("tracks") as! NSArray
        for track in trackList {
            let tAlbum = track.valueForKey("album") as! String
            let tArtist = track.valueForKey("artist") as! String
            let tLabel = track.valueForKey("label") as! String
            let tLength = track.valueForKey("length") as! NSNumber
            let tUrl = track.valueForKey("url") as! String
            let itemTrack = Track(title: tLabel, artist: tArtist, album: tAlbum, url: tUrl, length: tLength.integerValue, image: UIImage(named: "trackPlaceholder")!, radio: radio!)
            trackListArray.addObject(itemTrack)
        }
        trackQueueCollectionView.reloadData()
        updateUIWithTrack(0)
    }
    
    func getTrackList(radioID: Int) {
        let url: NSURL = NSURL(string: "http://muse.goprod.fr/api/ambiances/\(radioID)")!
        var mainPageRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(mainPageRequest, queue: queue, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if data != nil {
                    var parseError: NSError?
                    let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                        options: NSJSONReadingOptions.AllowFragments,
                        error:&parseError)
                    if (parsedObject != nil) {
                        self.createTrackListWithJson(parsedObject!)
                    }
                } else {
                }
                self.loaderImageView?.hide()
           })
        })
    }

    // MARK: UI Upadate and Management methods
    
    func updateUIWithTrack(trackID: Int) {
        if (trackListArray.count != 0) {
            let track = trackListArray.objectAtIndex(trackID) as! Track
            
            trackArtistLabel.text = track.trackArtist
            trackTitleLabel.text = track.trackTitle
        }
        if (!shouldShowPlayer) {
            playTrackWithID(trackID)
        }
        else {
            var theIndexOfTrack = 0
            for (index, t) in enumerate(trackListArray) {
                let tt = t as! Track
                if (tt.trackURL == playerShouldShowTrackWithURL) {
                    theIndexOfTrack = index
                }
                let newIndexPath = NSIndexPath(forRow: theIndexOfTrack, inSection: 0)
                trackQueueCollectionView.selectItemAtIndexPath(newIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
                let track = trackListArray.objectAtIndex(newIndexPath.row) as! Track
                trackArtistLabel.text = track.trackArtist
                trackTitleLabel.text = track.trackTitle
                let length = secondsToHoursMinutesSeconds(track.trackLength)
                var minutes = "\(length.1)"
                var seconds = "\(length.2)"
                if length.1 < 10 {
                    minutes = "0\(length.1)"
                }
                if length.2 < 10 {
                    seconds = "0\(length.2)"
                }
                timerLabel.text = "\(minutes):\(seconds)"
                playPauseButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            }
        }
    }
    
    @IBAction func volumeSliderMoved(sender: AnyObject) {
        let slider = sender as! UISlider
        AudioPlayerManager.sharedInstance.setPlayerVolume(slider.value)
    }
    
    @IBAction func playPauseButtonTouched(sender: AnyObject) {
        if (AudioPlayerManager.sharedInstance.isTrackPlaying()) {
            AudioPlayerManager.sharedInstance.pausePlayer()
            playPauseButton.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
        }
        else {
            AudioPlayerManager.sharedInstance.playPlayer()
            playPauseButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func favoriteButtonTouched(sender: AnyObject) {
        AudioPlayerManager.sharedInstance.playPlayer()
    }
    
    @IBAction func nextButtonTouched(sender: AnyObject) {
        trackEnd()
    }
    
    @IBAction func menuButtonTouched(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("playerDissmissed", object: nil)
        self.dismissViewControllerAnimated(true, completion: {
        })
    }

    // MARK: UICollectionView Protocols methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if ((collectionView.frame.size.height - collectionView.frame.size.width) > 0) {
            return CGSizeMake(collectionView.frame.size.width - 10, collectionView.frame.size.height - (collectionView.frame.size.height - collectionView.frame.size.width) - 10)
        }
        return CGSizeMake(collectionView.frame.size.width - 10, collectionView.frame.size.height)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (trackListArray.count != 0) {
            return trackListArray.count
        }
        return 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("playedTrack", forIndexPath: indexPath) as! UICollectionViewCell
        
        var coverImageView = cell.viewWithTag(2) as! UIImageView
        if (radio != nil) {
            coverImageView.kf_setImageWithURL(NSURL(string: radio!.radioImg)!,
                placeholderImage: nil,
                optionsInfo: [.Options: KingfisherOptions.LowPriority])
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        player.rate = 0.0
        for cell in trackQueueCollectionView.visibleCells() {
            let indexPath = trackQueueCollectionView.indexPathForCell(cell as! UICollectionViewCell)
            updateUIWithTrack(indexPath!.row)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
