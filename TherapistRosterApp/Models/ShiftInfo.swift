//
//  ShiftInfo.swift
//  TherapistRosterApp
//
//  Created by Jay on 7/1/20.
//  Copyright © 2020 Jay Son. All rights reserved.
//

import Foundation

struct ShiftInfo: Decodable {

    var start: Int // in seconds from the last midnight
    var duration: Int  // same as above

}
