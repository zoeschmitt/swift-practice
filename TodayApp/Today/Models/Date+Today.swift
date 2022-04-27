//
//  Date+Today.swift
//  Today
//
//  Created by Zoe Schmitt on 4/27/22.
//

import Foundation

// 17 Passing .omitted for the date style creates a string of only the time component.
// 19 You’ll include a translation table with your app, with an entry for each string and its translation. Call the NSLocalizedString(_:comment:) function to create a formatted time string. The comment parameter provides the translator with context about the localized string’s presentation to the user.

/// Represents date and time in a locale-aware format.
extension Date {
    var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
}
