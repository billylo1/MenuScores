//
//  RefreshCoordinator.swift
//  MenuScores
//

import Combine
import Foundation

enum RefreshInterval {
    static func timeInterval(for selectedOption: String) -> TimeInterval {
        switch selectedOption {
        case "10 seconds": return 10
        case "15 seconds": return 15
        case "20 seconds": return 20
        case "30 seconds": return 30
        case "40 seconds": return 40
        case "50 seconds": return 50
        case "1 minute": return 60
        case "2 minutes": return 120
        case "5 minutes": return 300
        default: return 15
        }
    }

    /// Slower polling for non-live games to cut energy use while a game remains set.
    static func effectiveInterval(userInterval: TimeInterval, gameState: String) -> TimeInterval {
        switch gameState {
        case "in":
            return userInterval
        case "pre":
            // Auto-monitor only: infrequent checks until the game goes live.
            return max(userInterval, 300)
        case "post":
            return max(userInterval, 300)
        default:
            return userInterval
        }
    }
}

/// Single main-run-loop timer for background score updates (replaces per-menu timers).
@MainActor
final class RefreshCoordinator {
    static let shared = RefreshCoordinator()

    private var timerCancellable: AnyCancellable?
    private var userInterval: TimeInterval = 15
    private var onTick: (() async -> Void)?
    private var isTickInFlight = false

    private(set) var isActive = false

    private init() {}

    func configure(interval: TimeInterval, onTick: @escaping () async -> Void) {
        userInterval = interval
        self.onTick = onTick
        reconcileTimer()
    }

    func setUserInterval(_ interval: TimeInterval) {
        userInterval = interval
        reconcileTimer()
    }

    func setShouldRun(_ shouldRun: Bool) {
        guard shouldRun != isActive else { return }
        isActive = shouldRun
        reconcileTimer()
    }

    func reconcileTimer(gameState: String? = nil) {
        let resolvedState = gameState ?? PinnedGameState.shared.gameState
        timerCancellable?.cancel()
        timerCancellable = nil
        guard isActive, let onTick else { return }

        let interval = RefreshInterval.effectiveInterval(
            userInterval: userInterval,
            gameState: resolvedState
        )

        timerCancellable = Timer.publish(every: interval, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                guard !self.isTickInFlight else { return }
                self.isTickInFlight = true
                Task {
                    await self.onTick?()
                    self.isTickInFlight = false
                }
            }
    }
}
