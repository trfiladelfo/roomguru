//
//  EventsListView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class EventsListView: UIBaseTableView {
    
    private var placeholderView: EmptyCalendarPlaceholderView!
    
    override func commonInit() {
        
        placeholderView = EmptyCalendarPlaceholderView(frame: frame)
        addSubview(placeholderView)
        
        super.commonInit()
        
        tableView.alpha = 0
        placeholderView.hidden = true
    }
    
    override func defineConstraints() {
        super.defineConstraints()
        
        layout(placeholderView) { placeholder in
            placeholder.edges == placeholder.superview!.edges; return
        }
    }
    
    func showPlaceholder(show: Bool = true, withIcon icon: FontAwesome = .CalendarO, text: String) {
        placeholderView.hidden = !show
        placeholderView.placeholderIconLabel.text = String.fontAwesomeIconWithName(icon)
        placeholderView.infoLabel.text = text
    }
}
