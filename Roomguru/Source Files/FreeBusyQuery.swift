//
//  FreeBusyQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 25/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire
import DateKit

class FreeBusyQuery: Query {
    
    var startDate: NSDate { get { return self[TimeMinKey] as NSDate } }
    var endDate: NSDate { get { return self[TimeMaxKey] as NSDate } }
    
    convenience init(calendarsIDs: [String]) {
        self.init(.POST, URLExtension: "/freeBusy")
        self[ItemsKey] = calendarsIDs.map { ["id": $0] }
    }
    
    required init(_ HTTPMethod: Alamofire.Method, URLExtension: String, parameters: QueryParameters? = nil, encoding: Alamofire.ParameterEncoding = .JSON) {
        super.init(HTTPMethod, URLExtension: URLExtension, parameters: parameters, encoding: encoding)
        
        let today = NSDate()
        self[TimeMinKey] = formatter.stringFromDate(today)
        self[TimeMaxKey] = formatter.stringFromDate(today.days + 2)
        self[TimeZoneKey] = "Europe/Warsaw"
    }
    
    
    // MARK: Private
    
    private let TimeMaxKey = "timeMax"
    private let TimeMinKey = "timeMin"
    private let TimeZoneKey = "timeZone"
    private let ItemsKey = "items"
}