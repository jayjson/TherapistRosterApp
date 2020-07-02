//
//  OnDutyViewController.swift
//  TherapistRosterApp
//
//  Created by Jay on 7/1/20.
//  Copyright © 2020 Jay Son. All rights reserved.
//

import UIKit

class OnDutyViewController: UITableViewController {

    let cellIdentifier = "onDutyInfoCell"

    var therapistsOnDuty = [Therapist]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        therapistsOnDuty = TherapistsDataManager.shared.getTherapistsOnDuty()
        therapistsOnDuty.sort {
            ($0.shiftInfo.start + $0.shiftInfo.duration) < ($1.shiftInfo.start + $1.shiftInfo.duration)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return therapistsOnDuty.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForAllTableViewCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OnDutyInfoCell
        let onDutyTherapist = therapistsOnDuty[indexPath.row]
        cell.nameLabel?.text = onDutyTherapist.lastName
        cell.licenseAndSinceDateLabel?.text = onDutyTherapist.licenseAndTherapistSinceInfoText
        cell.shiftInfoLabel?.text = onDutyTherapist.dutyInfoText + " " + onDutyTherapist.timeRemainingText
        return cell
    }
}
