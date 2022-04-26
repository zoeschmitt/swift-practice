/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData

    // WindowGroup is one of the primitive scenes that SwiftUI provides. In iOS, the views you add to the WindowGroup scene builder are presented in a window that fills the device’s entire screen.
    var body: some Scene {
        // SwiftUI provides primitive scenes like WindowGroup. The system manages the life cycle of scenes and displays the view hierarchy that’s platform- and context-appropriate. For example, multitasking on iPadOS can simultaneously display multiple smaller instances of the same app.
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: $scrums) // initial view
            }
        }
    }
}
