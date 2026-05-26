//
//  MenuBarStatusLabel.swift
//  MenuScores
//

import SwiftUI

/// Observes only pinned menubar title — not the full menu tree.
struct MenuBarStatusLabel: View {
    @ObservedObject private var pinned = PinnedGameState.shared

    var onPinnedGameIDChange: () -> Void = {}
    var onAppearAction: () -> Void = {}

    var body: some View {
        HStack {
            Image(systemName: "dot.radiowaves.left.and.right")
            Text(pinned.menubarTitle)
        }
        .onChange(of: pinned.gameID) { _ in onPinnedGameIDChange() }
        .onAppear(perform: onAppearAction)
    }
}
