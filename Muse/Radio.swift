//
//  Radio.swift
//  Muse
//
//  Created by Sacha BECOURT on 7/30/15.
//  Copyright (c) 2015 SB. All rights reserved.
//

import UIKit

class Radio: NSObject {
    var radioID: Int!
    var radioLabel: String!
    var radioItemCount: Int!
    var radioImg: String!
    
    init(radioID: Int, label: String, itemCount: Int, img: String) {
        self.radioID = radioID
        self.radioLabel = label
        self.radioItemCount = itemCount
        self.radioImg = img
    }
}
