//
//  ViewController.swift
//  Muse
//
//  Created by Sacha BECOURT on 7/30/15.
//  Copyright (c) 2015 SB. All rights reserved.
//

import UIKit
import Kingfisher


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var trackCoverImageView: UIImageView!
    @IBOutlet var trackArtistLabel: UILabel!
    @IBOutlet var trackTitleLabel: UILabel!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var bottomBarView: UIView!
    @IBOutlet var tracksCollectionView: UICollectionView!
    var radioArray = NSMutableArray(capacity: 0)
    var loaderImageView: AnimatedLoaderImageView?
    var obstacleViews : [UIView] = []
    var shouldJustShowPlayer = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tracksCollectionView.delegate = self
        tracksCollectionView.dataSource = self
        bottomBarView.hidden = true

        getRadioList()
        loaderImageView = AnimatedLoaderImageView(frame: (frame: CGRectMake(self.view.center.x - 75, self.view.center.y - 75, 150, 150)))
        self.view.addSubview(loaderImageView!)
        loaderImageView?.show()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didDismissSecondViewController"), name: "playerDissmissed", object: nil)
        obstacleViews.append(trackArtistLabel)
        obstacleViews.append(trackTitleLabel)
        obstacleViews.append(trackCoverImageView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UI Upadate and Management methods
    
    func updateBottomBarView() {
        let track = AudioPlayerManager.sharedInstance.getPlayingTrack() as Track
        trackArtistLabel.text = track.trackArtist
        trackTitleLabel.text = track.trackTitle
        let trackRadio = track.trackRadio as Radio
        trackCoverImageView.kf_setImageWithURL(NSURL(string: track.trackRadio.radioImg)!,
            placeholderImage: nil,
            optionsInfo: [.Options: KingfisherOptions.LowPriority])
    }
    
    func didDismissSecondViewController() {
        NSNotificationCenter.defaultCenter().removeObserver("playerDissmissed")
        if (AudioPlayerManager.sharedInstance.isTrackPlaying()) {
            playPauseButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            bottomBarView.hidden = false
            updateBottomBarView()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        testTouches(touches)
    }
    
    func testTouches(touches: NSSet!) {
        // Get the first touch and its location in this view controller's view coordinate system
        let touch = touches.allObjects[0] as! UITouch
        let touchLocation = touch.locationInView(self.view)
        
        for obstacleView in obstacleViews {
            // Convert the location of the obstacle view to this view controller's view coordinate system
            let obstacleViewFrame = self.view.convertRect(obstacleView.frame, fromView: obstacleView.superview)
            
            // Check if the touch is inside the obstacle view
            if CGRectContainsPoint(obstacleViewFrame, touchLocation) {
                // Touched bottom bar !
                shouldJustShowPlayer = true
                performSegueWithIdentifier("playTrack", sender: nil)
            }
        }
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
    
    // MARK: Data Fetch and Management methods
    
    func createRadioListWithJson(json: AnyObject) {
        let radioList = json.valueForKey("retour") as! NSArray
        for radio in radioList {
            let rID = radio.valueForKey("id") as! NSString
            let rLbl = radio.valueForKey("label") as! String
            let rICnt = radio.valueForKey("itemcount") as! NSNumber
            let rImg = radio.valueForKey("img") as! String
            var itemRadio = Radio(radioID: rID.integerValue, label: rLbl, itemCount: rICnt.integerValue, img: rImg)
            radioArray.addObject(itemRadio)
        }
        tracksCollectionView.reloadData()
    }
    
    func getRadioList() {
        let url: NSURL = NSURL(string: "http://muse.goprod.fr/api/ambiances")!
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
                        self.createRadioListWithJson(parsedObject!)
                    }
                } else {
                }
                self.loaderImageView?.hide()
            })
        })
    }

    // MARK: UICollectionView Protocols methods
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            if (UIScreen.mainScreen().scale > 2.9) {
                return UIEdgeInsetsMake(10, 25, 70, 25)
            }
            return UIEdgeInsetsMake(10, 11, 70, 11)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if radioArray.count != 0 {
            return radioArray.count
        }
        return 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cover", forIndexPath: indexPath) as! UICollectionViewCell
        
        var coverImageView = cell.viewWithTag(1) as! UIImageView
        if (radioArray.count != 0) {
            let radio = radioArray.objectAtIndex(indexPath.row) as! Radio
            coverImageView.kf_setImageWithURL(NSURL(string: radio.radioImg)!,
                placeholderImage: nil,
                optionsInfo: [.Options: KingfisherOptions.LowPriority])
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var segueID = segue.identifier
        if(segueID! == "playTrack"){
            var playerViewController = segue.destinationViewController as! PlayerViewController
            if let cell = sender as? UICollectionViewCell {
                let indexPath = tracksCollectionView.indexPathForCell(cell)
                if (radioArray.count != 0) {
                    playerViewController.radio = radioArray.objectAtIndex(indexPath!.row) as? Radio
                }
            }
            else {
                if (shouldJustShowPlayer) {
                    let track = AudioPlayerManager.sharedInstance.getPlayingTrack() as Track
                    playerViewController.shouldShowPlayer = true
                    playerViewController.playerShouldShowTrackWithURL = track.trackURL
                    playerViewController.radio = track.trackRadio
                }
            }
        }
    }

}

