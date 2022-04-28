//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Zoe Schmitt on 4/27/22.
//

import UIKit

// Because they have many responsibilities in UIKit apps, view controller files can be large. Reorganizing the view controller responsibilities into separate files and extensions makes it easier to find errors and add new features later.

// Collection view data sources manage the data in your collection view. They also create and configure the cells that the collection view uses to display items in your list.
// Lists can display cells for more than one type of data.

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    // Diffable data sources manage the state of your data with snapshots. A snapshot represents the state of your data at a specific point in time. To display data using a snapshot, you’ll create the snapshot, populate the snapshot with the state of data that you want to display, and then apply the snapshot in the user interface.
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>

    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }

    // Specifying an empty array as the default value for the parameter lets you call the method from viewDidLoad() without providing identifiers.
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        // You create a new snapshot when your collection view initially loads and whenever your app’s data changes.
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map { $0.id })

        if !ids.isEmpty {
            // reload the reminders for the identifiers.
            snapshot.reloadItems(ids)
        }

        // Applying the snapshot reflects the changes in the user interface.
        // When you apply an updated snapshot, the system calculates the differences between the two snapshots and animates the changes to the corresponding cells. (*DIFFABLE* data source)
        dataSource.apply(snapshot)
    }

    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(for: id)
        // defaultContentConfiguration() creates a content configuration with the predefined system style.
        var contentConfiguration = cell.defaultContentConfiguration()
        // The list displays the configuration text as the primary text of a cell.
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration

        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint

        cell.accessibilityCustomActions = [ doneButtonAccessibilityAction(for: reminder) ]
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        cell.accessories = [ .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always) ]

        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }

    func completeReminder(with id: Reminder.ID) {
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, with: id)
        updateSnapshot(reloading: [id])
    }

    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.id = reminder.id
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }

    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        // VoiceOver alerts users when actions are available for an object. If a user decides to hear the options, VoiceOver reads the name of each action.
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        // By default, closures create a strong reference to external values that you use inside them. Specifying a weak reference to the view controller prevents a retain cycle.
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(with: reminder.id)
            return true
        }
        return action
    }

    func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }

    func update(_ reminder: Reminder, with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders[index] = reminder
    }
}
