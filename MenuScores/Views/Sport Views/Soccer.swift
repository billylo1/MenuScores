//
//  Soccer.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-02.
//

import DynamicNotchKit
import SwiftUI

struct SoccerMenu: View {
    let title: String
    var viewModel: GamesListView
    let league: String
    let fetchURL: URL




    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0


       var body: some View {
        LeagueMenuShell(title: title, league: league, onAppearAction: {
            LeagueSelectionModel.shared.currentLeague = league
            Task {
                await viewModel.populateGames(from: fetchURL)
            }
        }) {
            SoccerMenuContent(
                title: title,
                viewModel: viewModel,
                league: league,
                fetchURL: fetchURL
            )
        }
    }
}

private struct SoccerMenuContent: View {
    let title: String
    @ObservedObject var viewModel: GamesListView
    let league: String
    let fetchURL: URL




    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0


       @StateObject private var notchViewModel = NotchViewModel()

    var body: some View {
            Text(formattedDate(from: viewModel.games.first?.date ?? "Invalid Date"))
                .font(.headline)
            Divider().padding(.bottom)

            if !viewModel.games.isEmpty {
                ForEach(Array(viewModel.games.enumerated()), id: \.1.id) { _, game in
                    Menu {
                        Button {
                            PinnedGameState.shared.pinToMenubar(
                                            title: displayText(for: game, league: league),
                                            gameID: game.id,
                                            state: game.status.type.state,
                                            league: league
                                        )
                                        LeagueSelectionModel.shared.setPinnedDetailURL(from: game)
                        } label: {
                            HStack {
                                Image(systemName: "menubar.rectangle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("Pin Game to Menubar")
                            }
                        }

                        if enableNotch {
                            Button {
                                PinnedGameState.shared.pinToNotch(
                                            gameID: game.id,
                                            state: game.status.type.state,
                                            league: league
                                        )
                                            notchViewModel.game = game

                                Task {
                                    if let existingNotch = NotchViewModel.shared.notch {
                                        await existingNotch.hide()
                                        NotchViewModel.shared.game = nil
                                        NotchViewModel.shared.currentGameID = ""
                                        NotchViewModel.shared.currentGameState = ""
                                        NotchViewModel.shared.previousGameState = ""
                                        NotchViewModel.shared.notch = nil
                                    }

                                    let newNotch = DynamicNotch(
                                        hoverBehavior: .all,
                                        style: .notch
                                    ) {
                                        Info(notchViewModel: notchViewModel, sport: "Soccer", league: "\(league)")
                                    } compactLeading: {
                                        CompactLeading(notchViewModel: notchViewModel, sport: "Soccer")
                                    } compactTrailing: {
                                        CompactTrailing(notchViewModel: notchViewModel, sport: "Soccer")
                                    }

                                    NotchViewModel.shared.notch = newNotch
                                    await newNotch.compact(on: NSScreen.screens[notchScreenIndex])
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "macbook")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    Text("Pin Game to Notch")
                                }
                            }
                        }

                        Button {
                            if let urlString = game.links?.first?.href, let url = URL(string: urlString) {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("View Game Details")
                            }
                        }
                    } label: {
                        HStack {
                            AsyncImage(
                                url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-soccer.png&h=80&w=80&scale=crop&cquality=40")
                            ) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: league))
                        }
                    }
                }
            } else {
                Text("Loading games...")
                    .foregroundColor(.gray)
                    .padding()
            }
    }
}
