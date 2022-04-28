//
//  ReminderViewController+Row.swift
//  Today
//
//  Created by Zoe Schmitt on 4/27/22.
//

import UIKit

extension ReminderViewController {
    // Diffable data sources that supply UIKit lists with data and styling require that items conform to Hashable. The diffable data source uses the hash values to determine what changed between two snapshots of the data.
    enum Row: Hashable {
        case viewDate
        case viewNotes
        case viewTime
        case viewTitle

        var imageName: String? {
            switch self {
            case .viewDate: return "calendar.circle"
            case .viewNotes: return "square.and.pencil"
            case .viewTime: return "clock"
            default: return nil
            }
        }

        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }

        var textStyle: UIFont.TextStyle {
            switch self {
            case .viewTitle: return .headline
            default: return .subheadline
            }
        }
    }

    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        cell.contentConfiguration = contentConfiguration
        cell.tintColor = .todayPrimaryTint
    }

    // You could use if statements to distinguish between details for applying relevant styling. However, by describing each row as a discrete case in an enumeration, you’ve made it easier to modify each row and potentially add more reminder details in the future.
    func text(for row: Row) -> String? {
        switch row {
        case .viewDate: return reminder.dueDate.dayText
        case .viewNotes: return reminder.notes
        case .viewTime: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .viewTitle: return reminder.title
        }
    }
}
