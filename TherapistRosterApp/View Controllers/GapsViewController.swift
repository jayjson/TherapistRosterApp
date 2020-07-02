//
//  GapsViewController.swift
//  TherapistRosterApp
//
//  Created by Jay on 7/1/20.
//  Copyright © 2020 Jay Son. All rights reserved.
//

import UIKit

class GapsViewController: UITableViewController {

    let cellIdentifier = "gapInfoCell"

    var secheduleGaps = [EmptyTimeSlot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secheduleGaps = TherapistsDataManager.shared.getEmptyTimeSlots()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secheduleGaps.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForAllTableViewCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GapInfoCell
        cell.gapInfoLabel?.text = secheduleGaps[indexPath.row].timeSlotInfoText
        return cell
    }
}
