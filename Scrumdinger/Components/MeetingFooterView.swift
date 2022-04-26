//
//  MeetingFooterView.swift
//  Scrumdinger
//
//  Created by Zoe Schmitt on 4/25/22.
//

import SwiftUI

struct MeetingFooterView: View {
    let speakers: [ScrumTimer.Speaker]
    var skipAction: ()->Void

    private var speakerNumber: Int? {
        guard let index = speakers.firstIndex(where: { !$0.isCompleted }) else { return nil}
        return index + 1
    }

    private var isLastSpeaker: Bool {
        // You can get the same result with reduce(_:_:) by returning speakers.dropLast().reduce(true) { $0 && $1.isCompleted }.
        return speakers.dropLast().allSatisfy { $0.isCompleted }
    }

    private var speakerText: String {
        guard let speakerNumber = speakerNumber else { return "No more speakers" }
        return "Speaker \(speakerNumber) of \(speakers.count)"
    }

    var body: some View {
        VStack {
            HStack {
                if isLastSpeaker {
                    Text("Last Speaker")
                } else {
                    Text(speakerText)
                    Spacer()
                    Button(action: skipAction) {
                        Image(systemName:"forward.fill")
                    }
                    .accessibilityLabel("Next speaker")
                }
            }
        }
        .padding([.bottom, .horizontal])
    }
}

struct MeetingFooterView_Previews: PreviewProvider {
    static var previews: some View {
        // You can set the preview layout to sizeThatFits to view a more accurate representation of the subview’s size.
        MeetingFooterView(speakers: DailyScrum.sampleData[0].attendees.speakers, skipAction: {})
            .previewLayout(.sizeThatFits)
    }
}
