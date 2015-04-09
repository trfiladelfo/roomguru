//
//  ButtonView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class ButtonView: UIView {
    
    let button = UIButton.buttonWithType(.System) as! UIButton
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Private
    
    private func commonInit() {
        configure()
        addSubview(button)
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(button) { _button in
            _button.edges == _button.superview!.edges; return
        }
    }

    private func configure() {
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        button.setTitleColor(UIColor.ngOrangeColor(), forState: .Normal)
    }
}
