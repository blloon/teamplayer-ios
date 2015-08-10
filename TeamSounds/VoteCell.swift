//
//  VoteCell.swift
//  TeamSounds
//
//  Created by Said Marouf on 7/29/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import Foundation
import UIKit

class VoteCell: UITableViewCell {
    
    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var upVotesLabel: UILabel!
    @IBOutlet weak private var downVotesLabel: UILabel!
    
    func updateForDynamicText() {
        refreshLayout()
    }
    
    func configureCell(header: String, upVotes: String, downVotes: String) {

        contentView.bounds = CGRect(x: 0.0, y: 0.0, width: 99999.0, height: 99999.0)
        
        headerLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        upVotesLabel.font = UIFont.boldSystemFontOfSize(19)
        downVotesLabel.font = UIFont.boldSystemFontOfSize(19)

        upVotesLabel.textColor = UIColor(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
        downVotesLabel.textColor = UIColor.redColor()
        
        headerLabel.text = header
        upVotesLabel.text = upVotes
        downVotesLabel.text = downVotes
        
        refreshLayout()
    }
    
    // Perform layout changes for your cell based on `expanded` status
    private func refreshLayout() {
        //self.contentView.setNeedsLayout()
        //self.contentView.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.layoutIfNeeded()
        self.headerLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.headerLabel.frame) - 20

    }
}