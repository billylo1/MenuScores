//
//  PinnedGameSync.swift
//  MenuScores
//

import Foundation

enum PinnedGameSync {
    @MainActor
    static func syncStandardEvent(
        gameID: String,
        league: String,
        game: Event?,
        notiGameStart: Bool,
        notiGameComplete: Bool
    ) {
        guard !gameID.isEmpty, gameID != "0", let game else { return }

        let pinnedToNotch = NotchViewModel.shared.notch != nil
            && (NotchViewModel.shared.currentGameID == gameID || NotchViewModel.shared.game?.id == gameID)

        let state = PinnedGameState.shared
        let uiChanged = state.updateFromStandardEvent(
            game,
            league: league,
            pinnedToNotch: pinnedToNotch,
            notiGameStart: notiGameStart,
            notiGameComplete: notiGameComplete
        )

        guard pinnedToNotch else { return }

        if uiChanged || NotchViewModel.shared.game?.id != game.id {
            NotchViewModel.shared.game = game
        }
    }
}
