//
//  gamesListView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import Foundation

@MainActor
class GamesListView: ObservableObject {
    @Published var games: [Event] = []
    private var lastFingerprint: String = ""

    func populateGames(from url: URL) async {
        do {
            let fetched = try await getGames().getGamesArray(url: url)
            let fingerprint = Self.fingerprint(fetched)
            guard fingerprint != lastFingerprint else { return }
            lastFingerprint = fingerprint
            games = fetched
        } catch {
            print("Failed to fetch games:", error)
        }
    }

    func game(withID id: String) -> Event? {
        games.first { $0.id == id }
    }

    private static func fingerprint(_ games: [Event]) -> String {
        games.map { game in
            let scores = game.competitions.first?.competitors?
                .map { "\($0.id ?? ""):\($0.score ?? "")" }
                .joined(separator: ",") ?? ""
            let state = game.status.type.state
            let clock = game.status.displayClock ?? ""
            let period = game.status.period.map(String.init) ?? ""
            return "\(game.id)|\(state)|\(period)|\(clock)|\(scores)"
        }.joined(separator: ";")
    }
}

struct GameListView {
    private var game: Event

    init(game: Event) {
        self.game = game
    }
}

// MARK: Tennis Only

@MainActor
class TennisListView: ObservableObject {
    @Published var tennisGames: [TennisEvent] = []
    private var lastFingerprint: String = ""

    func populateTennis(from url: URL) async {
        do {
            let fetched = try await getGames().getTennisArray(url: url)
            let fingerprint = Self.fingerprint(fetched)
            guard fingerprint != lastFingerprint else { return }
            lastFingerprint = fingerprint
            tennisGames = fetched
        } catch {
            print("Failed to fetch games:", error)
        }
    }

    private static func fingerprint(_ games: [TennisEvent]) -> String {
        games.map { game in
            let state = game.status.type.state
            return "\(game.id)|\(state)"
        }.joined(separator: ";")
    }
}

struct TennisGameListView {
    private var game: TennisEvent

    init(game: TennisEvent) {
        self.game = game
    }
}
