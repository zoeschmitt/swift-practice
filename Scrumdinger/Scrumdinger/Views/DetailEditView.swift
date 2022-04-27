//
//  DetailEditView.swift
//  Scrumdinger
//
//  Created by Zoe Schmitt on 4/24/22.
//

import SwiftUI

struct DetailEditView: View {
    // Recall that the @State property wrapper defines the source of truth for value types.
    // Declare @State properties as private so they can be accessed only within the view in which you define them.
    @Binding var data: DailyScrum.Data
    @State private var newAttendeeName = ""

    var body: some View {
        // The Form container automatically adapts the appearance of controls when it renders on different platforms.
        Form {
            Section(header: Text("Meeting Info")) {
                //  You can use the $ syntax to create a binding to data.title.
                TextField("Title", text: $data.title)
                HStack {
                    // A Slider stores a Double from a continuous range that you specify. Passing a step value of 1 limits the user to choosing whole numbers.
                    Slider(value: $data.lengthInMinutes, in: 5...30, step: 1) {
                        // The Text view won’t appear on screen, but VoiceOver uses it to identify the purpose of the slider.
                        Text("Length")
                    }
                    .accessibilityValue("\(Int(data.lengthInMinutes)) minutes")
                    Spacer()
                    Text("\(Int(data.lengthInMinutes)) minutes")
                        .accessibilityHidden(true)
                }
                ThemePicker(selection: $data.theme)
            }
            Section(header: Text("Attendees")) {
                ForEach(data.attendees) { attendee in
                    Text(attendee.name)
                }
                .onDelete { indices in
                    // The framework calls the closure you pass to onDelete when the user swipes to delete a row.
                    data.attendees.remove(atOffsets: indices)
                }
            }
            HStack {
                TextField("New Attendee", text: $newAttendeeName)
                Button(action: {
                    withAnimation {
                        let attendee = DailyScrum.Attendee(name: newAttendeeName)
                        data.attendees.append(attendee)
                        newAttendeeName = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .accessibilityLabel("Add attendee")
                }
                .disabled(newAttendeeName.isEmpty)
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(DailyScrum.sampleData[0].data))
    }
}
