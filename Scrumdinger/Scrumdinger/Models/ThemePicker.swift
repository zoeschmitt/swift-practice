//
//  ThemePicker.swift
//  Scrumdinger
//
//  Created by Zoe Schmitt on 4/25/22.
//

import SwiftUI

struct ThemePicker: View {
    @Binding var selection: Theme

    var body: some View {
        Picker("Theme", selection: $selection) {
            // allCases made possible by Them conforming to CaseIterable, Iterable
            ForEach(Theme.allCases) { theme in
                ThemeView(theme: theme)
                    .tag(theme) // You can tag subviews when you need to differentiate among them in controls like pickers and lists. Tag values can be any hashable type like in an enumeration.
            }
        }
    }
}

struct ThemePicker_Previews: PreviewProvider {
    // You can use the constant(_:) type method to create a binding to a hard-coded, immutable value. Constant bindings are useful in previews or when prototyping your app’s UI.
    static var previews: some View {
        ThemePicker(selection: .constant(.periwinkle))
    }
}
