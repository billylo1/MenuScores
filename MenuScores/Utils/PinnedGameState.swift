//
//  PinnedGameState.swift
//  MenuScores
//

import Foundation

/// Menubar / pinned-game state isolated from the menu tree so score ticks don't re-render every league menu.
@MainActor
final class PinnedGameState: ObservableObject {
    static let shared = PinnedGameState()

    @Published private(set) var menubarTitle: String = ""
    @Published private(set) var gameID: String = ""
    @Published private(set) var gameState: String = "pre"
    @Published private(set) var previousGameState: String?

    /// Set from `MenuScoresApp` to start/stop background refresh when pin changes.
    var onPinStateChanged: (() -> Void)?

    private init() {}

    var hasActivePin: Bool {
        !gameID.isEmpty && gameID != "0"
    }

    func pinToMenubar(title: String, gameID: String, state: String, league: String) {
        menubarTitle = title
        self.gameID = gameID
        gameState = state
        previousGameState = state
        LeagueSelectionModel.shared.currentLeague = league
        onPinStateChanged?()
    }

    func pinToNotch(gameID: String, state: String, league: String) {
        menubarTitle = ""
        self.gameID = gameID
        gameState = state
        previousGameState = state
        LeagueSelectionModel.shared.currentLeague = league
        onPinStateChanged?()
    }

    func applyAutoMonitor(title: String, gameID: String, state: String, league: String) {
        let prior = (self.gameID == gameID) ? gameState : nil
        menubarTitle = title
        self.gameID = gameID
        gameState = state
        previousGameState = prior
        LeagueSelectionModel.shared.currentLeague = league
        onPinStateChanged?()
    }

    func clear() {
        menubarTitle = ""
        gameID = ""
        gameState = "pre"
        previousGameState = nil
        LeagueSelectionModel.shared.currentGameDetailURL = ""
        onPinStateChanged?()
    }

    @discardableResult
    func updateFromStandardEvent(
        _ game: Event,
        league: String,
        pinnedToNotch: Bool,
        notiGameStart: Bool,
        notiGameComplete: Bool
    ) -> Bool {
        let newState = AutoMonitorFavorite.effectiveStandardState(league: league, game: game)
        let newTitle = pinnedToNotch ? "" : displayText(for: game, league: league)

        let titleChanged = menubarTitle != newTitle
        let stateChanged = gameState != newState
        guard titleChanged || stateChanged else { return false }

        if titleChanged {
            menubarTitle = newTitle
        }

        if notiGameStart, previousGameState != "in", newState == "in" {
            gameStartNotification(gameId: gameID, gameTitle: menubarTitle, newState: newState)
        }
        if notiGameComplete, previousGameState != "post", newState == "post" {
            gameCompleteNotification(gameId: gameID, gameTitle: menubarTitle, newState: newState)
        }

        if stateChanged {
            previousGameState = gameState
            gameState = newState
            NotchViewModel.shared.currentGameState = newState
        }

        return true
    }
}
