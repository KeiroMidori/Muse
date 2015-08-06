//
//  AnimatedLoaderImageView.swift
//  Muse
//
//  Created by Sacha BECOURT on 7/30/15.
//  Copyright (c) 2015 SB. All rights reserved.
//

import UIKit

class AnimatedLoaderImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var loaderImagesArray = NSMutableArray(capacity: 0)
        for (var i = 1; i <= 40; i++) {
            loaderImagesArray.addObject(UIImage(named: "loader_\(i).png")!)
        }
        self.animationImages = loaderImagesArray as [AnyObject]
        self.animationDuration = 3
        self.startAnimating()
        self.transform = CGAffineTransformScale(self.transform, 1.5, 1.5);
        self.alpha = 0.0
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1
        })
    }

    func show() {
        UIView.animateWithDuration(0.3, animations: {
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1
        })
    }
    
    func hide() {
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 0.0
            self.transform = CGAffineTransformScale(self.transform, 1.5, 1.5);
            }, completion: { (done: Bool) -> Void in
                self.stopAnimating()
                self.removeFromSuperview()
        })
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
