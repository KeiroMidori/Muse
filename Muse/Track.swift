//
//  Track.swift
//  Muse
//
//  Created by Sacha BECOURT on 7/30/15.
//  Copyright (c) 2015 SB. All rights reserved.
//

import UIKit

class Track: NSObject {
    var trackTitle: String!
    var trackArtist: String!
    var trackAlbum: String!
    var trackURL: String!
    var trackLength: Int!
    var trackImage: UIImage!
    var trackRadio: Radio!
    
    init(title: String, artist: String, album: String, url: String, length: Int, image: UIImage, radio: Radio) {
        self.trackTitle = title
        self.trackArtist = artist
        self.trackAlbum = album
        self.trackURL = url
        self.trackLength = length
        self.trackImage = image
        self.trackRadio = radio
    }
    
    required init(coder aDecoder: NSCoder) {
        self.trackTitle = aDecoder.decodeObjectForKey("trackTitle") as! String
        self.trackArtist = aDecoder.decodeObjectForKey("trackArtist") as! String
        self.trackAlbum = aDecoder.decodeObjectForKey("trackAlbum") as! String
        self.trackURL = aDecoder.decodeObjectForKey("trackURL") as! String
        self.trackLength = aDecoder.decodeObjectForKey("trackLength") as! Int
        self.trackImage = aDecoder.decodeObjectForKey("trackImage") as! UIImage
        self.trackRadio = aDecoder.decodeObjectForKey("trackRadio") as! Radio

    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(self.trackTitle, forKey: "trackTitle")
        _aCoder.encodeObject(self.trackArtist, forKey: "trackArtist")
        _aCoder.encodeObject(self.trackAlbum, forKey: "trackAlbum")
        _aCoder.encodeObject(self.trackURL, forKey: "trackURL")
        _aCoder.encodeObject(self.trackLength, forKey: "trackLength")
        _aCoder.encodeObject(self.trackImage, forKey: "trackImage")
        _aCoder.encodeObject(self.trackRadio, forKey: "trackRadio")
    }
}
