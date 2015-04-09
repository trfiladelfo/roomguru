//
//  TimeFrame.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TimeFrameAvailability {
    
    case Available, NotAvailable
}

class TimeFrame: ModelObject {
    
    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    var availability: TimeFrameAvailability = .NotAvailable
        
    init(startDate: NSDate, endDate: NSDate, availability: TimeFrameAvailability) {
        self.startDate = startDate
        self.endDate = endDate
        self.availability = availability
        super.init()
    }

    required init(json: JSON) {
        super.init(json: json)
    }
    
    override func map(json: JSON) {
        if let start = json["start"].string {
            startDate = formatter.dateFromString(start)!
        }
        
        if let end = json["end"].string {
            endDate = formatter.dateFromString(end)!
        }
    }
    
    override class func map<T where T : ModelJSONProtocol>(jsonArray: [JSON]?) -> [T]? {
        if let _jsonArray = jsonArray {
            if _jsonArray.isEmpty {
                return nil
            }
            return _jsonArray.map { T(json: $0) }
        }
        
        return nil
    }
}

extension TimeFrame {
    
    func duration() -> NSTimeInterval {
        return endDate.timeIntervalSinceDate(startDate)
    }
}

// MARK: Debug

extension TimeFrame: Printable {
    
    override var description: String {
        return "\nstart: \(self.startDate), end: \(self.endDate), duration: \(self.duration()), availability: \(self.availability)"
    }
}

extension TimeFrameAvailability: Printable {
    
    var description: String {
        
        switch self {
        case .Available:
            return "Available"
        case .NotAvailable:
            return "Not available"
        }
    }
}
