//
//  EmptyTimeSlot.swift
//  TherapistRosterApp
//
//  Created by Jay on 7/1/20.
//  Copyright © 2020 Jay Son. All rights reserved.
//

import Foundation

struct EmptyTimeSlot {

    var startTime: Date
    var endTime: Date
    
    var timeSlotInfoText: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let startTimeAsString = formatter.string(from: startTime)
        let endTimeAsString = formatter.string(from: endTime)
        return "No Therapist: \(startTimeAsString) to \(endTimeAsString)"
    }
    
}
