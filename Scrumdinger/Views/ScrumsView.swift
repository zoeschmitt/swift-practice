//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Zoe Schmitt on 4/24/22.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @State private var isPresentingNewScrumView = false
    @State private var newScrumData = DailyScrum.Data()
    // SwiftUI indicates the current operational state of your app’s Scene instances with a scenePhase Environment value.
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void

    var body: some View {
        List {

            /// The problem with using a title like property as an id is that if their are repeated values it can fuck things up

//            ForEach(scrums, id: \.title) { scrum in
//                CardView(scrum: scrum)
//                    .listRowBackground(scrum.theme.mainColor)
//            }

            /// Which is why you need to define an Id UUID in DailyScrum model.

            ForEach($scrums) { $scrum in
                NavigationLink(destination: DetailView(scrum: $scrum)) {
                    CardView(scrum: scrum)
                        .listRowBackground(scrum.theme.mainColor)
                }
            }
        }
        .navigationTitle("Daily Scrums")
        // Notice that you add the .navigationTitle modifier to the List. The child view can affect the appearance of the NavigationView using modifiers.
        .toolbar {
            Button(action: {
                isPresentingNewScrumView = true
            }) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")
        }
        .sheet(isPresented: $isPresentingNewScrumView) {
            NavigationView {
                DetailEditView(data: $newScrumData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewScrumView = false
                                newScrumData = DailyScrum.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newScrum = DailyScrum(data: newScrumData)
                                scrums.append(newScrum)
                                isPresentingNewScrumView = false
                                newScrumData = DailyScrum.Data()
                            }
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { phase in
            // A scene in the inactive phase no longer receives events and may be unavailable to the user.
            if phase == .inactive { saveAction() }
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        // Adding the NavigationView displays navigation elements, like title and bar buttons, on the canvas. For now, the preview displays padding for a navigation title.
        NavigationView {
            ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
        }
    }
}
