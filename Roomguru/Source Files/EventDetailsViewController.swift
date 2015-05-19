//
//  EventDetailsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import AFNetworking

class EventDetailsViewController: UIViewController {
    
    private weak var aView: EventDetailsView?
    private let viewModel: EventDetailsViewModel
    
    // MARK: View life cycle
    
    init(event: Event?) {
        self.viewModel = EventDetailsViewModel(event: event)
        super.init(nibName: nil, bundle: nil);
    }

    required init(coder aDecoder: NSCoder) {
        self.viewModel = EventDetailsViewModel(event: nil)
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        aView = loadViewWithClass(EventDetailsView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideBackBarButtonTitle()
        
        if viewModel.isEventEditable() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "didTapEditBarButton:")
        }

        title = NSLocalizedString("Event Details", comment: "")
        setupTableView()
    }
}

// MARK: UITableViewDelegate

extension EventDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

// MARK: UITableViewDataSource

extension EventDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return viewModel.numberOfLocations()
        case 3: return viewModel.numberOfGuests()
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(DescriptionCell.self)
            cell.textLabel?.attributedText = viewModel.summary()
            
            return cell
            
        case 1...3:
            let cell = tableView.dequeueReusableCell(AttendeeCell.self)
            let info = attendeeInfoForIndexPath(indexPath)
            
            cell.headerLabel.text = info.name
            cell.footerLabel.text = info.email
            cell.statusLabel.text = viewModel.iconWithStatus(info.status)

            // hide for locations:
            cell.footerLabel.hidden = (indexPath.section == 1)
            
            if let url = NSURL.gravatarURLWithEmail(info.email) {
                cell.avatarView.imageView.setImageWithURL(url)
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(ButtonCell.self)
            cell.button.setTitle(NSLocalizedString("Join Hangout meeting!", comment: ""))
            cell.button.addTarget(self, action: "didTapHangoutButton:")
            cell.button.backgroundColor = UIColor.ngOrangeColor()
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            let width = CGRectGetWidth(self.view.frame) - 2 * DescriptionCell.margins().H
            return viewModel.summary().boundingHeightUsingAvailableWidth(width) + 2 * DescriptionCell.margins().V
        default:
            return 61
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        default:
            return 30
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = HeaderLabel()
        
        switch section {
        case 1: label.text = NSLocalizedString("Location", comment: "")
        case 2: label.text = NSLocalizedString("Organizer", comment: "")
        case 3: label.text = NSLocalizedString("Participants", comment: "")
        case 4: label.text = NSLocalizedString("Possibilities", comment: "")
        default:
            label.text = nil
        }
        return label
    }
}

// MARK: UIControl Methods

extension EventDetailsViewController {
    
    func didTapHangoutButton(sender: UIButton) {
        
        UIApplication.openURLIfPossible(viewModel.hangoutURL()) { (success, error) in
            if let error = error {
                UIAlertView(error: error).show()
            }
        }
    }
}

// MARK: Actions

extension EventDetailsViewController {

    func didTapEditBarButton(sender: UIBarButtonItem) {
        let event = self.viewModel.event!
        let calendarEntry = CalendarEntry(calendarID: event.rooms!.first!.email!, event: event)
        let viewModel = EditEventViewModel(calendarEntry: calendarEntry)
        let editEventController = EditEventViewController(viewModel: viewModel)
        let navigationController = NavigationController(rootViewController: editEventController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

// MARK: Private

private extension EventDetailsViewController {
    
    func attendeeInfoForIndexPath(indexPath: NSIndexPath) -> AttendeeInfo {
        if indexPath.section == 1 {
            return viewModel.location(indexPath.row)
        } else if indexPath.section == 2 {
            return viewModel.owner()
        } else {
            return viewModel.attendee(indexPath.row)
        }
    }
    
    func setupTableView() {
        aView?.tableView.delegate = self;
        aView?.tableView.dataSource = self;
        aView?.tableView.registerClass(AttendeeCell.self)
        aView?.tableView.registerClass(DescriptionCell.self)
        aView?.tableView.registerClass(ButtonCell.self)
    }
}
