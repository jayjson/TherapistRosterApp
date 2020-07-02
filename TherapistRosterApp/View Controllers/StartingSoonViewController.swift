//
//  ComingUpViewController.swift
//  TherapistRosterApp
//
//  Created by Jay on 7/1/20.
//  Copyright © 2020 Jay Son. All rights reserved.
//

import UIKit

class StartingSoonViewController: UITableViewController {

    let cellIdentifier = "startingSoonInfoCell"

    var therapistsStartingSoon = [Therapist]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        therapistsStartingSoon = TherapistsDataManager.shared.getTherapistsStartingSoon()
        therapistsStartingSoon.sort { $0.shiftInfo.start < $1.shiftInfo.start }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return therapistsStartingSoon.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForAllTableViewCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StartingSoonInfoCell
        let startingSoonTherapist = therapistsStartingSoon[indexPath.row]
        cell.nameLabel?.text = startingSoonTherapist.lastName
        cell.licenseAndSinceDateLabel?.text = startingSoonTherapist.licenseAndTherapistSinceInfoText
        cell.shiftInfoLabel?.text = startingSoonTherapist.dutyInfoText + " " + startingSoonTherapist.timeRemainingText
        return cell
    }
}
