//
//  Therapist.swift
//  TherapistRosterApp
//
//  Created by Jay on 7/1/20.
//  Copyright © 2020 Jay Son. All rights reserved.
//

import Foundation

struct TherapistsGroup: Decodable {

    var therapists: [Therapist]

}

struct Therapist: Decodable {

    let id: Int
    let therapistSince: Date
    let primaryLicense: String
    let name: String
    let shiftInfo: ShiftInfo
    
    // MARK: -For display in table view cells
    var lastName: String {
        let fullNameArray = name.components(separatedBy: " ")
        guard let lastName = fullNameArray.last else { return "" }
        return lastName
    }
    
    var licenseAndTherapistSinceInfoText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let therapistSinceAsString = formatter.string(from: therapistSince)
        return primaryLicense + " since " + therapistSinceAsString
    }
    
    var dutyInfoText: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let startTimeAsString = formatter.string(from: startTimeInGMT)
        let endTimeAsString = formatter.string(from: endTimeInGMT)
        return "On Duty: " + startTimeAsString + " to " + endTimeAsString + "."
    }
    
    var timeRemainingText: String {
        let currentTimeInGMT = Date()
        if currentTimeInGMT < startTimeInGMT { // Case 1: Shift starting soon
            let timeRemaining = startTimeInGMT.timeIntervalSince1970 - currentTimeInGMT.timeIntervalSince1970
            let hours = Int((timeRemaining/Double(3600)).rounded(.down))
            let remainingSeconds = Int(timeRemaining) % 3600
            let remainingMinutes = Int((Double(remainingSeconds)/Double(60)).rounded(.up))
            if hours == 0 { return "\(remainingMinutes) min till start" }
            else { return "\(hours) hr \(remainingMinutes) min till start" }
        } else if currentTimeInGMT >= startTimeInGMT && currentTimeInGMT < endTimeInGMT { // Case 2: Now on duty
            let timeRemaining = endTimeInGMT.timeIntervalSince1970 - currentTimeInGMT.timeIntervalSince1970
            let hours = Int((timeRemaining/Double(3600)).rounded(.down))
            let remainingSeconds = Int(timeRemaining) % 3600
            let remainingMinutes = Int((Double(remainingSeconds)/Double(60)).rounded())
            if hours == 0 { return "\(remainingMinutes) min till end" }
            else { return "\(hours) hr \(remainingMinutes) min till end" }
        } else { // Case 3: Shift finished. This part should not be reached.
            assertionFailure("Error: Shift finished")
            return ""
        }
    }

    // MARK: -For extracting Date info
    var startTimeInGMT: Date {
        let timeNow = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        let lastMidnightTime = calendar.startOfDay(for: timeNow)
        let timeIntervalDelta = TimeInterval(shiftInfo.start)
        let startTimeAsGMTDate = lastMidnightTime.addingTimeInterval(timeIntervalDelta)
        return startTimeAsGMTDate
    }
    
    var endTimeInGMT: Date {
        let timeNow = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        let lastMidnightTime = calendar.startOfDay(for: timeNow)
        let timeIntervalDelta = TimeInterval(shiftInfo.start + shiftInfo.duration)
        let endTimeAsGMTDate = lastMidnightTime.addingTimeInterval(timeIntervalDelta)
        return endTimeAsGMTDate
    }
    
    // MARK: -Related to therapist status
    var isOnDuty: Bool {
        let currentTimeInGMT = Date()
        if currentTimeInGMT >= startTimeInGMT && currentTimeInGMT < endTimeInGMT {
            return true
        } else {
            return false
        }
    }
    
    var isStartingSoonToday: Bool {
        let currentTimeInGMT = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        let startOfTheDayInGMT = calendar.startOfDay(for: currentTimeInGMT)
        let endOfTheDayInGMT = startOfTheDayInGMT.addingTimeInterval(TimeInterval(60*60*24))
        if startTimeInGMT > currentTimeInGMT && startTimeInGMT < endOfTheDayInGMT {
            return true
        } else {
            return false
        }
    }
    
}
