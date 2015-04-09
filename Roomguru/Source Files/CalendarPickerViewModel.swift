//
//  CalendarPickerViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 02/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CalendarPickerViewModel: NSObject {

    let calendars: [Calendar]
    private var selectedCalendars: [Calendar]
    
    init(calendars: [Calendar]) {
        self.calendars = calendars
        self.selectedCalendars = calendars.matchingCalendars()
        super.init()
    }
    // MARK: Public
    
    func saveOrRemoveItemAtIndex(index: Int) {
        
        let calendar = calendars[index]
        if selectedCalendars.contains(calendar) {
            selectedCalendars.removeObject(calendar)
        } else {
            selectedCalendars += [calendar]
        }
    }
    
    func shouldSelectCalendar(calendar: Calendar) -> Bool {
        return selectedCalendars.contains(calendar)
    }
    
    func shouldProcceed() -> Bool {
        return !selectedCalendars.isEmpty
    }
    
    func save() {
        CalendarPersistenceStore.sharedStore.saveCalendars(selectedCalendars)
    }
    
    func textForCalendar(calendar: Calendar) -> (mainText: String?, detailText: String?) {
        
        let placeholder = NSLocalizedString("Not change yet", comment: "")
        let mainText = calendar.name ?? calendar.summary
        var detailText = (calendar.name != nil) ? calendar.summary : placeholder
        
        if (detailText != nil) && (detailText != placeholder) {
            detailText = NSLocalizedString("was: ", comment: "") + detailText!
        }
        return (mainText, detailText)
    }
}

extension Array {
    
    func matchingCalendars() -> [T] {
        return self.filter {
            for calendar in CalendarPersistenceStore.sharedStore.calendars {
                if $0 as! Calendar == calendar { return true }
            }
            return false
        }
    }
}
