//
//  RevocableEventCell.swift
//  Roomguru
//
//  Created by Aleksander Popko on 24.04.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class RevocableEventCell: EventCell {
    
    private let revokeButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var revokeButtonHandler : VoidBlock?
    
    override class func reuseIdentifier() -> String {
        return "TableViewRevocableEventCellReuseIdentifier"
    }
    
    override func commonInit() {
        
        revokeButton.setTitle(NSLocalizedString("Revoke", comment: ""))
        revokeButton.setTitleColor(UIColor.ngRedColor(), forState: .Normal)
        revokeButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        revokeButton.addTarget(self, action: Selector("didTapRevokeButton:"))
        contentView.addSubview(revokeButton)
        
        super.commonInit()
    }
    
    override func defineConstraints() {
        super.defineConstraints()
        
        layout(revokeButton) { aButton in
            aButton.centerY == aButton.superview!.centerY
            aButton.right == aButton.superview!.right - 10
            aButton.width == 65
            aButton.height == 35
        }
    }
    
    func didTapRevokeButton(sender:UIButton) {
        if let handler = revokeButtonHandler {
            handler()
        }
    }
    
    override func setStyle(style: EventCellDisplayStyle) {
        super.setStyle(style)
        
        switch style {
        case .Past:
            revokeButton.hidden = true
        case .Current, .Future:
            revokeButton.hidden = false
        }
    }
}
