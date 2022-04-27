/*
 See LICENSE folder for this sample’s licensing information.
 */

import UIKit

//A UICollectionViewListCell has three configuration properties:
//
//contentConfiguration — Describes the cell’s labels, images, buttons, and more
//
//backgroundConfiguration — Describes the cell’s background color, gradient, image, and other visual attributes
//
//configurationState — Describes the cell’s style when the user selects, highlights, drags, or otherwise interacts with it

class ReminderListViewController: UICollectionViewController {
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout

        // Cell registration specifies how to configure the content and appearance of a cell.
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        // In the initializer, you pass a closure that configures and returns a cell for a collection view. The closure accepts two inputs: an index path to the location of the cell in the collection view and an item identifier.
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            // You could create a new cell for every item, but the initialization cost would degrade your app’s performance. Reusing cells allows your app to perform well even with a vast number of items.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}


