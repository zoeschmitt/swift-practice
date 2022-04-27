//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Zoe Schmitt on 4/27/22.
//

import UIKit

extension ReminderListViewController {
    // The @objc attribute makes this method available to Objective-C code.
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(with: id)
    }
}
