/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    // Wrapping a property as a @StateObject means the view owns the source of truth for the object. @StateObject ties the ScrumTimer, which is an ObservableObject, to the MeetingView life cycle.
    @StateObject var scrumTimer = ScrumTimer()
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.theme.mainColor)
            VStack {
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)
                MeetingTimerView(speakers: scrumTimer.speakers, theme: scrum.theme)
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }
            .foregroundColor(scrum.theme.accentColor)
            .onAppear {
                scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
                scrumTimer.speakerChangedAction = {
                    player.seek(to: .zero)
                    player.play()
                }
                scrumTimer.startScrum()
            }
            .onDisappear {
                scrumTimer.stopScrum()
                let newHistory = History(attendees: scrum.attendees, lengthInMinutes: scrum.timer.secondsElapsed / 60)
                scrum.history.insert(newHistory, at: 0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
