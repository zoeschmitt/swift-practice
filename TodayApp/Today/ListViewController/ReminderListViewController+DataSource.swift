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
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    // Diffable data sources manage the state of your data with snapshots. A snapshot represents the state of your data at a specific point in time. To display data using a snapshot, you’ll create the snapshot, populate the snapshot with the state of data that you want to display, and then apply the snapshot in the user interface.
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: String) {
        let reminder = Reminder.sampleData[indexPath.item]
        // defaultContentConfiguration() creates a content configuration with the predefined system style.
        var contentConfiguration = cell.defaultContentConfiguration()
        // The list displays the configuration text as the primary text of a cell.
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration

        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint

        cell.accessories = [ .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always) ]

        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }

    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = UIButton()
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
}
