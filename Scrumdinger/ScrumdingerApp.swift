/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData

    // WindowGroup is one of the primitive scenes that SwiftUI provides. In iOS, the views you add to the WindowGroup scene builder are presented in a window that fills the device’s entire screen.
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: $scrums) // initial view
            }
        }
    }
}
