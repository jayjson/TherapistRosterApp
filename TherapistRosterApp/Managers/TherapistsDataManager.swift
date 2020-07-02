//
//  TherapistsDataManager.swift
//  TherapistRosterApp
//
//  Created by Jay on 7/1/20.
//  Copyright © 2020 Jay Son. All rights reserved.
//

import Foundation

class TherapistsDataManager {

    static let shared = TherapistsDataManager()

    private var existingTherapists = [Therapist]()

    private init() {
        loadSeedData()
    }
    
    private func loadSeedData() {
        guard let url = Bundle.main.url(forResource: "therapistsData", withExtension: "json") else {
            assertionFailure("The file wasn't found.")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let seedData = try decoder.decode(TherapistsGroup.self, from: data)
            existingTherapists = seedData.therapists
        } catch {
            assertionFailure("Seed data import failed")
            return
        }
    }
    
    func getTherapistsOnDuty() -> [Therapist] {
        return existingTherapists.filter { $0.isOnDuty }
    }

    func getTherapistsStartingSoon() -> [Therapist] {
        return existingTherapists.filter { $0.isStartingSoonToday }
    }
    
    func getEmptyTimeSlots() -> [EmptyTimeSlot] {
        var emptyTimeSlotsFound = [EmptyTimeSlot]()
        // Make a copy of the therapists list and sort by the start time
        var tempTherapists = existingTherapists
        tempTherapists.sort { $0.shiftInfo.start < $1.shiftInfo.start }
        // Get the last midnight time
        let now = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        let startOfToday = calendar.startOfDay(for: now)
        // Evaluate each pair of consecutive therapist time blocks while keeping track of the latest time checked
        var latestTimeSoFar = startOfToday
        for i in 0..<tempTherapists.count {
            let timeBlockOneEndTime = latestTimeSoFar
            let timeBlockTwoStartTime = tempTherapists[i].startTimeInGMT
            let timeBlockTwoEndTime = tempTherapists[i].endTimeInGMT
            if timeBlockOneEndTime < timeBlockTwoStartTime { // Case 1: A gap exists between the first and second time blocks. Create an EmptyTimeSlot object.
                emptyTimeSlotsFound.append(EmptyTimeSlot(startTime: timeBlockOneEndTime, endTime: timeBlockTwoStartTime))
                latestTimeSoFar = timeBlockTwoEndTime
            } else if timeBlockOneEndTime >= timeBlockTwoStartTime && timeBlockOneEndTime <= timeBlockTwoEndTime { // Case 2: The two time blocks overlap. No gap exists between them.
                latestTimeSoFar = timeBlockTwoEndTime
            } else if timeBlockOneEndTime > timeBlockTwoEndTime { // Case 3: The second time block is within the first time block. No gap exists between them.
                latestTimeSoFar = timeBlockOneEndTime
            } else {
                assertionFailure("There shouldn't be any other case.")
                return []
            }
        }
        // Handle the rest of the day
        if let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfToday), latestTimeSoFar < startOfNextDay {
            emptyTimeSlotsFound.append(EmptyTimeSlot(startTime: latestTimeSoFar, endTime: startOfNextDay))
        }
        return emptyTimeSlotsFound
    }

}
