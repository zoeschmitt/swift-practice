//
//  SpeakerArc.swift
//  Scrumdinger
//
//  Created by Zoe Schmitt on 4/26/22.
//

import SwiftUI

struct SpeakerArc: Shape {
    // The speaker index indicates which attendee is speaking and how many segments to draw.
    let speakerIndex: Int
    let totalSpeakers: Int

    private var degreesPerSpeaker: Double {
        360.0 / Double(totalSpeakers)
    }

    // When you draw a path, you’ll need an angle for the start and end of the arc. The additional 1.0 degree is for visual separation between arc segments.
    private var startAngle: Angle {
        Angle(degrees: degreesPerSpeaker * Double(speakerIndex) + 1.0)
    }

    // The subtracted 1.0 degree is for visual separation between arc segments.
    private var endAngle: Angle {
        Angle(degrees: startAngle.degrees + degreesPerSpeaker - 1.0)
    }

    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}
