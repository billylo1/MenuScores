//
//  UFC.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-11-22.
//

import DynamicNotchKit
import SwiftUI

struct UFCMenu: View {
    let title: String
    @ObservedObject var viewModel: GamesListView
    let league: String
    let fetchURL: URL

    @StateObject private var notchViewModel = NotchViewModel()

    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0

    var body: some View {}
}
