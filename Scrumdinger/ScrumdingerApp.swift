/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

@main
struct ScrumdingerApp: App {
    @StateObject private var store = ScrumStore()
    // The default value of an optional is nil. When you assign a value to this state variable, SwiftUI updates the view.
    @State private var errorWrapper: ErrorWrapper?

    // WindowGroup is one of the primitive scenes that SwiftUI provides. In iOS, the views you add to the WindowGroup scene builder are presented in a window that fills the device’s entire screen.
    var body: some Scene {
        // SwiftUI provides primitive scenes like WindowGroup. The system manages the life cycle of scenes and displays the view hierarchy that’s platform- and context-appropriate. For example, multitasking on iPadOS can simultaneously display multiple smaller instances of the same app.
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: $store.scrums) {
                    /// Dispatch way
//                    ScrumStore.save(scrums: store.scrums) { result in
//                        if case .failure(let error) = result {
//                            fatalError(error.localizedDescription)
//                        }
//                    }
                    /// async way
                    Task {
                        do {
                            try await ScrumStore.save(scrums: store.scrums)
                        } catch {
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                        }
                    }
                } // initial view
            }
            /// async way
            .task {
                do {
                    store.scrums = try await ScrumStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Scrumdinger will load sample data and continue.")
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {
                store.scrums = DailyScrum.sampleData
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
            /// Dispatch way
//            .onAppear {
//                ScrumStore.load { result in
//                    switch result {
//                    case .failure(let error):
//                        fatalError(error.localizedDescription)
//                    case .success(let scrums):
//                        store.scrums = scrums
//                    }
//                }
//            }
        }
    }
}
