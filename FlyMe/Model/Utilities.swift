//
//  Utilities.swift
//  FlyMe
//
//  Created by Dalibor Kozak on 13/10/2019.
//  Copyright © 2019 Dalibor Kozak. All rights reserved.
//

import UIKit

struct Utilities {
    
    static func dateWith(format: String, value: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "cz_CZ")
        let d1 = Date(timeIntervalSince1970: Double(value))
        return formatter.string(from: d1)
    }
    
    static func dateWith(format: String, date: Date?) -> String? {
        guard let date = date else { return nil}
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "cz_CZ")
        return formatter.string(from: date)
    }
    
    static func duration(_ value: Int) -> String {
        return String(String(value / 60 / 60) + ":" + String(value / 60 % 60))
    }
    
    static func dateIn(days: Int) -> Date? {
        var comp = DateComponents()
        comp.day = days
        return Calendar.current.date(byAdding: comp, to: Date())
    }
}

struct Constants {
    static let baseUrlFlight                = "https://api.skypicker.com/flights"
    static let baseUrlImage                 = "https://images.kiwi.com/photos/1280x720/"
    static let placeholderWidth: CGFloat    = 640
    static let timeFormat                   = "HH:mm:ss"
    static let dateFormat                   = "dd MMM YY"
    static let dateFormatRequest            = "dd/MM/YYYY"
    static let currency                     = "Euro"
    static let kiwiColor                    = UIColor.init(displayP3Red: 0, green: 169/255, blue: 145/255, alpha: 1)
}
