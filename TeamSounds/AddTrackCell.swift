//
//  VoteCell.swift
//  TeamSounds
//
//  Created by Said Marouf on 7/29/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class AddTrackCell: UITableViewCell {
    
    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    @IBOutlet weak var addTrackButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    
    func updateForDynamicText() {

    }
    
    func configureCell(header: String, content: String, coverURLString: String?) {
        
        headerLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        contentLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        headerLabel.text = header
        contentLabel.text = content
   
        headerLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
            
        coverImageView.layer.cornerRadius = 22
        coverImageView.layer.masksToBounds = true
        coverImageView.alpha = 0.0
        coverImageView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        if let coverURLString = coverURLString {
            
            weak var weakSelf = self
            coverImageView.setImageFromURL(NSURL(string: coverURLString)) { (result) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.9, options: nil, animations: {
                    weakSelf?.coverImageView.alpha = 1.0
                    weakSelf?.coverImageView.transform = CGAffineTransformIdentity
                    }, completion: {finished in
                
                })
            }
        }
   
        if count(content) == 0 {
            contentLabel.frame = CGRectZero
        }
        
        contentView.bounds = CGRect(x: 0.0, y: 0.0, width: 99999.0, height: 99999.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = 60//approximated from IB
        headerLabel.preferredMaxLayoutWidth = contentView.frame.width - margin
        contentLabel.preferredMaxLayoutWidth = contentView.frame.width - margin
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.coverImageView.image = nil
    }
}