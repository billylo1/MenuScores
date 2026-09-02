//
//  MenuScoresApp.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import AppKit
import SwiftUI

class LeagueSelectionModel: ObservableObject {
    @Published var currentLeague: String = ""
    @Published var currentGameDetailURL: String = ""

    func setPinnedDetailURL(from event: Event) {
        currentGameDetailURL = event.links?.first?.href ?? ""
    }

    func setPinnedDetailURL(from event: TennisEvent) {
        currentGameDetailURL = event.links?.first?.href ?? ""
    }
}

extension LeagueSelectionModel {
    static let shared = LeagueSelectionModel()
}

@main
struct MenuScoresApp: App {
    // Refresh Interval Settings

    @AppStorage("refreshInterval") private var selectedOption = "15 seconds"

    private var refreshInterval: TimeInterval {
        RefreshInterval.timeInterval(for: selectedOption)
    }

    // Toggled League Settings

    @AppStorage("enableNHL") private var enableNHL = true
    @AppStorage("enableHNCAAM") private var enableHNCAAM = false
    @AppStorage("enableHNCAAF") private var enableHNCAAF = false

    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = false
    @AppStorage("enableNCAAM") private var enableNCAAM = false
    @AppStorage("enableNCAAF") private var enableNCAAF = false

    @AppStorage("enableNFL") private var enableNFL = true
    @AppStorage("enableFNCAA") private var enableFNCAA = false

    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableBNCAA") private var enableBNCAA = false
    @AppStorage("enableSNCAA") private var enableSNCAA = false

    @AppStorage("enableF1") private var enableF1 = true
    @AppStorage("enableNC") private var enableNC = false
    @AppStorage("enableNCS") private var enableNCS = false
    @AppStorage("enableNCT") private var enableNCT = false
    @AppStorage("enableIRL") private var enableIRL = false

    @AppStorage("enablePGA") private var enablePGA = true
    @AppStorage("enableLPGA") private var enableLPGA = false

    @AppStorage("enableMLS") private var enableMLS = true
    @AppStorage("enableNWSL") private var enableNWSL = false
    @AppStorage("enableUEFA") private var enableUEFA = false
    @AppStorage("enableEUEFA") private var enableEUEFA = false
    @AppStorage("enableWUEFA") private var enableWUEFA = false
    @AppStorage("enableMEX") private var enableMEX = false
    @AppStorage("enableFRA") private var enableFRA = false
    @AppStorage("enableNED") private var enableNED = false
    @AppStorage("enablePOR") private var enablePOR = false
    @AppStorage("enableEPL") private var enableEPL = false
    @AppStorage("enableWEPL") private var enableWEPL = false
    @AppStorage("enableESP") private var enableESP = false
    @AppStorage("enableGER") private var enableGER = false
    @AppStorage("enableITA") private var enableITA = false

    @AppStorage("enableFFWC") private var enableFFWC = false
    @AppStorage("enableFFWWC") private var enableFFWWC = false
    @AppStorage("enableFFWCQUEFA") private var enableFFWCQUEFA = false
    @AppStorage("enableCONCACAF") private var enableCONCACAF = false
    @AppStorage("enableCONMEBOL") private var enableCONMEBOL = false
    @AppStorage("enableCAF") private var enableCAF = false
    @AppStorage("enableAFC") private var enableAFC = false
    @AppStorage("enableOFC") private var enableOFC = false

    @AppStorage("enableATP") private var enableATP = true
    @AppStorage("enableWTA") private var enableWTA = false

    @AppStorage("enableUFC") private var enableUFC = true

    @AppStorage("enableNLL") private var enableNLL = true
    @AppStorage("enablePLL") private var enablePLL = false
    @AppStorage("enableLNCAAM") private var enableLNCAAM = false
    @AppStorage("enableLNCAAF") private var enableLNCAAF = false

    @AppStorage("enableVNCAAM") private var enableVNCAAM = true
    @AppStorage("enableVNCAAF") private var enableVNCAAF = false

    @AppStorage("enableOMIHC") private var enableOMIHC = true
    @AppStorage("enableOWIHC") private var enableOWIHC = false

    @AppStorage("autoMonitorEnabled") private var autoMonitorEnabled = false
    @AppStorage("autoMonitorFavorite") private var autoMonitorFavorite = ""

    @MainActor
    private func enabledLeagueCodes() -> [String] {
        buildScoreboardEventSources().map(\.league) + buildTennisSources().map(\.league)
    }

    private func refreshAllLeagues() async {
        for code in enabledLeagueCodes() {
            await refreshLeague(code)
        }
    }

    @MainActor
    private func refreshLeague(_ code: String) async {
        switch code {
        case "NHL": await nhlVM.populateGames(from: Scoreboard.Urls.nhl)
        case "HNCAAM": await hncaamVM.populateGames(from: Scoreboard.Urls.hncaam)
        case "HNCAAF": await hncaafVM.populateGames(from: Scoreboard.Urls.hncaaf)
        case "NBA": await nbaVM.populateGames(from: Scoreboard.Urls.nba)
        case "WNBA": await wnbaVM.populateGames(from: Scoreboard.Urls.wnba)
        case "NCAA M": await ncaamVM.populateGames(from: Scoreboard.Urls.ncaam)
        case "NCAA F": await ncaafVM.populateGames(from: Scoreboard.Urls.ncaaf)
        case "NFL": await nflVM.populateGames(from: Scoreboard.Urls.nfl)
        case "FNCAA": await fncaaVM.populateGames(from: Scoreboard.Urls.fncaa)
        case "MLB": await mlbVM.populateGames(from: Scoreboard.Urls.mlb)
        case "BNCAA": await bncaaVM.populateGames(from: Scoreboard.Urls.bncaa)
        case "SNCAA": await sncaaVM.populateGames(from: Scoreboard.Urls.sncaa)
        case "F1": await f1VM.populateGames(from: Scoreboard.Urls.f1)
        case "NC": await ncVM.populateGames(from: Scoreboard.Urls.nc)
        case "NCS": await ncsVM.populateGames(from: Scoreboard.Urls.ncs)
        case "NCT": await nctVM.populateGames(from: Scoreboard.Urls.nct)
        case "IRL": await irlVM.populateGames(from: Scoreboard.Urls.irl)
        case "PGA": await pgaVM.populateGames(from: Scoreboard.Urls.pga)
        case "LPGA": await lpgaVM.populateGames(from: Scoreboard.Urls.lpga)
        case "MLS": await mlsVM.populateGames(from: Scoreboard.Urls.mls)
        case "NWSL": await nwslVM.populateGames(from: Scoreboard.Urls.nwsl)
        case "UEFA": await uefaVM.populateGames(from: Scoreboard.Urls.uefa)
        case "EUEFA": await euefaVM.populateGames(from: Scoreboard.Urls.euefa)
        case "WUEFA": await wuefaVM.populateGames(from: Scoreboard.Urls.wuefa)
        case "EPL": await eplVM.populateGames(from: Scoreboard.Urls.epl)
        case "WEPL": await weplVM.populateGames(from: Scoreboard.Urls.wepl)
        case "ESP": await espVM.populateGames(from: Scoreboard.Urls.esp)
        case "GER": await gerVM.populateGames(from: Scoreboard.Urls.ger)
        case "ITA": await itaVM.populateGames(from: Scoreboard.Urls.ita)
        case "MEX": await mexVM.populateGames(from: Scoreboard.Urls.mex)
        case "FRA": await fraVM.populateGames(from: Scoreboard.Urls.fra)
        case "NED": await nedVM.populateGames(from: Scoreboard.Urls.ned)
        case "POR": await porVM.populateGames(from: Scoreboard.Urls.por)
        case "FFWC": await ffwcVM.populateGames(from: Scoreboard.Urls.ffwc)
        case "FFWWC": await ffwwcVM.populateGames(from: Scoreboard.Urls.ffwwc)
        case "FFWCQUEFA": await ffwcquefaVM.populateGames(from: Scoreboard.Urls.ffwcquefa)
        case "CONMEBOL": await conmebolVM.populateGames(from: Scoreboard.Urls.conmebol)
        case "CONCACAF": await concacafVM.populateGames(from: Scoreboard.Urls.concacaf)
        case "CAF": await cafVM.populateGames(from: Scoreboard.Urls.caf)
        case "AFC": await afcVM.populateGames(from: Scoreboard.Urls.afc)
        case "OFC": await ofcVM.populateGames(from: Scoreboard.Urls.ofc)
        case "ATP": await atpVM.populateTennis(from: Scoreboard.Urls.atp)
        case "WTA": await wtaVM.populateTennis(from: Scoreboard.Urls.wta)
        case "NLL": await nllVM.populateGames(from: Scoreboard.Urls.nll)
        case "PLL": await pllVM.populateGames(from: Scoreboard.Urls.pll)
        case "LNCAAM": await lncaamVM.populateGames(from: Scoreboard.Urls.lncaam)
        case "LNCAAF": await lncaafVM.populateGames(from: Scoreboard.Urls.lncaaf)
        case "VNCAAM": await vncaamVM.populateGames(from: Scoreboard.Urls.vncaam)
        case "VNCAAF": await vncaafVM.populateGames(from: Scoreboard.Urls.vncaaf)
        case "OMIHC": await omihcVM.populateGames(from: Scoreboard.Urls.omihc)
        case "OWIHC": await owihcVM.populateGames(from: Scoreboard.Urls.owihc)
        default: break
        }
    }

    private var hasPinnedOrActiveNotch: Bool {
        PinnedGameState.shared.hasActivePin || NotchViewModel.shared.notch != nil
    }

    @MainActor
    private func shouldRunPeriodicRefresh() -> Bool {
        let favoriteActive = autoMonitorEnabled
            && !AutoMonitorFavorite.normalizedQuery(autoMonitorFavorite).isEmpty
        if favoriteActive { return true }

        guard hasPinnedOrActiveNotch else { return false }

        // Scheduled games: no polling until they go live (use menu open or Refresh).
        return PinnedGameState.shared.gameState != "pre"
    }

    @MainActor
    private func reconcileBackgroundRefresh() {
        RefreshCoordinator.shared.setShouldRun(shouldRunPeriodicRefresh())
        RefreshCoordinator.shared.reconcileTimer(gameState: PinnedGameState.shared.gameState)
    }

    @MainActor
    private func gamesViewModel(for league: String) -> GamesListView? {
        switch league {
        case "NHL": return nhlVM
        case "HNCAAM": return hncaamVM
        case "HNCAAF": return hncaafVM
        case "NBA": return nbaVM
        case "WNBA": return wnbaVM
        case "NCAA M": return ncaamVM
        case "NCAA F": return ncaafVM
        case "NFL": return nflVM
        case "FNCAA": return fncaaVM
        case "MLB": return mlbVM
        case "BNCAA": return bncaaVM
        case "SNCAA": return sncaaVM
        case "F1": return f1VM
        case "NC": return ncVM
        case "NCS": return ncsVM
        case "NCT": return nctVM
        case "IRL": return irlVM
        case "PGA": return pgaVM
        case "LPGA": return lpgaVM
        case "MLS": return mlsVM
        case "NWSL": return nwslVM
        case "UEFA": return uefaVM
        case "EUEFA": return euefaVM
        case "WUEFA": return wuefaVM
        case "EPL": return eplVM
        case "WEPL": return weplVM
        case "ESP": return espVM
        case "GER": return gerVM
        case "ITA": return itaVM
        case "MEX": return mexVM
        case "FRA": return fraVM
        case "NED": return nedVM
        case "POR": return porVM
        case "FFWC": return ffwcVM
        case "FFWWC": return ffwwcVM
        case "FFWCQUEFA": return ffwcquefaVM
        case "CONMEBOL": return conmebolVM
        case "CONCACAF": return concacafVM
        case "CAF": return cafVM
        case "AFC": return afcVM
        case "OFC": return ofcVM
        case "NLL": return nllVM
        case "PLL": return pllVM
        case "LNCAAM": return lncaamVM
        case "LNCAAF": return lncaafVM
        case "VNCAAM": return vncaamVM
        case "VNCAAF": return vncaafVM
        case "OMIHC": return omihcVM
        case "OWIHC": return owihcVM
        default: return nil
        }
    }

    @MainActor
    private func backgroundRefreshTick() async {
        let pinned = PinnedGameState.shared
        var leaguesToRefresh = Set<String>()

        if autoMonitorEnabled {
            let hub = AutoMonitorHub.shared
            if hub.needsCacheBootstrap {
                await refreshAllLeagues()
                hub.markCachesBootstrapped()
            } else {
                leaguesToRefresh.formUnion(hub.leaguesToRefreshThisTick())
            }
        }

        if hasPinnedOrActiveNotch, pinned.gameState != "pre" {
            let league = LeagueSelectionModel.shared.currentLeague
            if !league.isEmpty {
                leaguesToRefresh.insert(league)
            }
        }

        for league in leaguesToRefresh {
            await refreshLeague(league)
        }

        if autoMonitorEnabled {
            AutoMonitorHub.shared.scanAndApply()
        }

        if hasPinnedOrActiveNotch {
            let league = LeagueSelectionModel.shared.currentLeague
            guard !league.isEmpty else { return }
            let game = gamesViewModel(for: league)?.game(withID: pinned.gameID)
            let priorState = pinned.gameState
            PinnedGameSync.syncStandardEvent(
                gameID: pinned.gameID,
                league: league,
                game: game,
                notiGameStart: notiGameStart,
                notiGameComplete: notiGameComplete
            )
            if pinned.gameState != priorState {
                reconcileBackgroundRefresh()
            }
        }
    }

    @MainActor
    private func buildScoreboardEventSources() -> [(league: String, games: [Event])] {
        var rows: [(String, [Event])] = []
        if enableNHL { rows.append(("NHL", nhlVM.games)) }
        if enableHNCAAM { rows.append(("HNCAAM", hncaamVM.games)) }
        if enableHNCAAF { rows.append(("HNCAAF", hncaafVM.games)) }

        if enableNBA { rows.append(("NBA", nbaVM.games)) }
        if enableWNBA { rows.append(("WNBA", wnbaVM.games)) }
        if enableNCAAM { rows.append(("NCAA M", ncaamVM.games)) }
        if enableNCAAF { rows.append(("NCAA F", ncaafVM.games)) }

        if enableNFL { rows.append(("NFL", nflVM.games)) }
        if enableFNCAA { rows.append(("FNCAA", fncaaVM.games)) }

        if enableMLB { rows.append(("MLB", mlbVM.games)) }
        if enableBNCAA { rows.append(("BNCAA", bncaaVM.games)) }
        if enableSNCAA { rows.append(("SNCAA", sncaaVM.games)) }

        if enableF1 { rows.append(("F1", f1VM.games)) }
        if enableNC { rows.append(("NC", ncVM.games)) }
        if enableNCS { rows.append(("NCS", ncsVM.games)) }
        if enableNCT { rows.append(("NCT", nctVM.games)) }
        if enableIRL { rows.append(("IRL", irlVM.games)) }

        if enablePGA { rows.append(("PGA", pgaVM.games)) }
        if enableLPGA { rows.append(("LPGA", lpgaVM.games)) }

        if enableMLS { rows.append(("MLS", mlsVM.games)) }
        if enableNWSL { rows.append(("NWSL", nwslVM.games)) }
        if enableUEFA { rows.append(("UEFA", uefaVM.games)) }
        if enableEUEFA { rows.append(("EUEFA", euefaVM.games)) }
        if enableWUEFA { rows.append(("WUEFA", wuefaVM.games)) }
        if enableEPL { rows.append(("EPL", eplVM.games)) }
        if enableWEPL { rows.append(("WEPL", weplVM.games)) }
        if enableESP { rows.append(("ESP", espVM.games)) }
        if enableGER { rows.append(("GER", gerVM.games)) }
        if enableITA { rows.append(("ITA", itaVM.games)) }
        if enableMEX { rows.append(("MEX", mexVM.games)) }
        if enableFRA { rows.append(("FRA", fraVM.games)) }
        if enableNED { rows.append(("NED", nedVM.games)) }
        if enablePOR { rows.append(("POR", porVM.games)) }

        if enableFFWC { rows.append(("FFWC", ffwcVM.games)) }
        if enableFFWWC { rows.append(("FFWWC", ffwwcVM.games)) }
        if enableFFWCQUEFA { rows.append(("FFWCQUEFA", ffwcquefaVM.games)) }
        if enableCONMEBOL { rows.append(("CONMEBOL", conmebolVM.games)) }
        if enableCONCACAF { rows.append(("CONCACAF", concacafVM.games)) }
        if enableCAF { rows.append(("CAF", cafVM.games)) }
        if enableAFC { rows.append(("AFC", afcVM.games)) }
        if enableOFC { rows.append(("OFC", ofcVM.games)) }

        if enableNLL { rows.append(("NLL", nllVM.games)) }
        if enablePLL { rows.append(("PLL", pllVM.games)) }
        if enableLNCAAM { rows.append(("LNCAAM", lncaamVM.games)) }
        if enableLNCAAF { rows.append(("LNCAAF", lncaafVM.games)) }

        if enableVNCAAM { rows.append(("VNCAAM", vncaamVM.games)) }
        if enableVNCAAF { rows.append(("VNCAAF", vncaafVM.games)) }

        if enableOMIHC { rows.append(("OMIHC", omihcVM.games)) }
        if enableOWIHC { rows.append(("OWIHC", owihcVM.games)) }
        return rows
    }

    @MainActor
    private func buildTennisSources() -> [(league: String, games: [TennisEvent])] {
        var rows: [(String, [TennisEvent])] = []
        if enableATP { rows.append(("ATP", atpVM.tennisGames)) }
        if enableWTA { rows.append(("WTA", wtaVM.tennisGames)) }
        return rows
    }

    @MainActor
    private func resolveDetailsURL(for gameID: String) -> URL? {
        eventDetailsURL(for: gameID, in: buildScoreboardEventSources())
            ?? tennisDetailsURL(for: gameID, in: buildTennisSources())
    }

    @MainActor
    private func syncCurrentGameDetailURL() {
        let model = LeagueSelectionModel.shared
        let gameID = PinnedGameState.shared.gameID
        if model.currentGameDetailURL.isEmpty,
           let resolved = resolveDetailsURL(for: gameID)
        {
            model.currentGameDetailURL = resolved.absoluteString
        }
    }

    @MainActor
    private func openSetGameDetails() {
        let pinned = PinnedGameState.shared
        guard !pinned.menubarTitle.isEmpty else { return }

        let model = LeagueSelectionModel.shared
        let urlString = model.currentGameDetailURL.isEmpty
            ? resolveDetailsURL(for: pinned.gameID)?.absoluteString
            : model.currentGameDetailURL

        guard let urlString, !urlString.isEmpty, let url = URL(string: urlString) else { return }

        if model.currentGameDetailURL.isEmpty {
            model.currentGameDetailURL = urlString
        }

        NSWorkspace.shared.open(url)
    }

    // Notification Settings

    @AppStorage("notiGameStart") private var notiGameStart = false
    @AppStorage("notiGameComplete") private var notiGameComplete = false

    // Notch Data

    @StateObject private var notchViewModel = NotchViewModel()

    // Notch Behaviors

    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0

    // League Fetching

    @StateObject private var nhlVM = GamesListView()
    @StateObject private var hncaamVM = GamesListView()
    @StateObject private var hncaafVM = GamesListView()

    @StateObject private var nbaVM = GamesListView()
    @StateObject private var wnbaVM = GamesListView()
    @StateObject private var ncaamVM = GamesListView()
    @StateObject private var ncaafVM = GamesListView()

    @StateObject private var nflVM = GamesListView()
    @StateObject private var fncaaVM = GamesListView()

    @StateObject private var mlbVM = GamesListView()
    @StateObject private var bncaaVM = GamesListView()
    @StateObject private var sncaaVM = GamesListView()

    @StateObject private var f1VM = GamesListView()
    @StateObject private var ncVM = GamesListView()
    @StateObject private var ncsVM = GamesListView()
    @StateObject private var nctVM = GamesListView()
    @StateObject private var irlVM = GamesListView()

    @StateObject private var pgaVM = GamesListView()
    @StateObject private var lpgaVM = GamesListView()

    @StateObject private var uefaVM = GamesListView()
    @StateObject private var euefaVM = GamesListView()
    @StateObject private var wuefaVM = GamesListView()
    @StateObject private var mlsVM = GamesListView()
    @StateObject private var nwslVM = GamesListView()
    @StateObject private var mexVM = GamesListView()
    @StateObject private var fraVM = GamesListView()
    @StateObject private var nedVM = GamesListView()
    @StateObject private var porVM = GamesListView()
    @StateObject private var eplVM = GamesListView()
    @StateObject private var weplVM = GamesListView()
    @StateObject private var espVM = GamesListView()
    @StateObject private var gerVM = GamesListView()
    @StateObject private var itaVM = GamesListView()

    @StateObject private var ffwcVM = GamesListView()
    @StateObject private var ffwwcVM = GamesListView()
    @StateObject private var ffwcquefaVM = GamesListView()
    @StateObject private var conmebolVM = GamesListView()
    @StateObject private var concacafVM = GamesListView()
    @StateObject private var cafVM = GamesListView()
    @StateObject private var afcVM = GamesListView()
    @StateObject private var ofcVM = GamesListView()

    @StateObject private var atpVM = TennisListView()
    @StateObject private var wtaVM = TennisListView()

//    @StateObject private var ufcVM = GamesListView()

    @StateObject private var nllVM = GamesListView()
    @StateObject private var pllVM = GamesListView()
    @StateObject private var lncaamVM = GamesListView()
    @StateObject private var lncaafVM = GamesListView()

    @StateObject private var vncaamVM = GamesListView()
    @StateObject private var vncaafVM = GamesListView()

    @StateObject private var omihcVM = GamesListView()
    @StateObject private var owihcVM = GamesListView()

    var body: some Scene {
        MenuBarExtra {
            Button {
                openSetGameDetails()
            } label: {
                HStack {
                    Image(systemName: "info.circle")
                    Text("Open Set Game Details")
                }
            }
            .disabled(PinnedGameState.shared.menubarTitle.isEmpty)
            .stableMenuBarItem("menu-open-details")

            Divider()
                .stableMenuBarItem("menu-divider-open-details")

            if enableNHL {
                HockeyMenu(
                    title: "NHL",
                    viewModel: nhlVM,
                    league: "NHL",
                    fetchURL: Scoreboard.Urls.nhl
                )
            }

            if enableHNCAAM {
                HockeyMenu(
                    title: "NCAA M Hockey",
                    viewModel: hncaamVM,
                    league: "HNCAAM",
                    fetchURL: Scoreboard.Urls.hncaam
                )
            }

            if enableHNCAAF {
                HockeyMenu(
                    title: "NCAA F Hockey",
                    viewModel: hncaafVM,
                    league: "HNCAAF",
                    fetchURL: Scoreboard.Urls.hncaaf
                )
            }

            if enableNBA {
                BasketballMenu(
                    title: "NBA",
                    viewModel: nbaVM,
                    league: "NBA",
                    fetchURL: Scoreboard.Urls.nba
                )
            }

            if enableWNBA {
                BasketballMenu(
                    title: "WNBA",
                    viewModel: wnbaVM,
                    league: "WNBA",
                    fetchURL: Scoreboard.Urls.wnba
                )
            }

            if enableNCAAM {
                BasketballMenu(
                    title: "NCAA M Basketball",
                    viewModel: ncaamVM,
                    league: "NCAA M",
                    fetchURL: Scoreboard.Urls.ncaam
                )
            }

            if enableNCAAF {
                BasketballMenu(
                    title: "NCAA F Basketball",
                    viewModel: ncaafVM,
                    league: "NCAA F",
                    fetchURL: Scoreboard.Urls.ncaaf
                )
            }

            if enableNFL {
                FootballMenu(
                    title: "NFL",
                    viewModel: nflVM,
                    league: "NFL",
                    fetchURL: Scoreboard.Urls.nfl
                )
            }

            if enableFNCAA {
                FootballMenu(
                    title: "NCAA Football",
                    viewModel: fncaaVM,
                    league: "FNCAA",
                    fetchURL: Scoreboard.Urls.fncaa
                )
            }

            if enableMLB {
                BaseballMenu(
                    title: "MLB",
                    viewModel: mlbVM,
                    league: "MLB",
                    fetchURL: Scoreboard.Urls.mlb
                )
            }

            if enableBNCAA {
                BaseballMenu(
                    title: "NCAA Baseball",
                    viewModel: bncaaVM,
                    league: "BNCAA",
                    fetchURL: Scoreboard.Urls.bncaa
                )
            }

            if enableSNCAA {
                BaseballMenu(
                    title: "NCAA Softball",
                    viewModel: sncaaVM,
                    league: "SNCAA",
                    fetchURL: Scoreboard.Urls.sncaa
                )
            }

            if enableMLS {
                SoccerMenu(
                    title: "MLS",
                    viewModel: mlsVM,
                    league: "MLS",
                    fetchURL: Scoreboard.Urls.mls
                )
            }

            if enableNWSL {
                SoccerMenu(
                    title: "NWSL",
                    viewModel: nwslVM,
                    league: "NWSL",
                    fetchURL: Scoreboard.Urls.nwsl
                )
            }

            if enableUEFA {
                SoccerMenu(
                    title: "Champions League",
                    viewModel: uefaVM,
                    league: "UEFA",
                    fetchURL: Scoreboard.Urls.uefa
                )
            }

            if enableEUEFA {
                SoccerMenu(
                    title: "Europa Champions League",
                    viewModel: euefaVM,
                    league: "EUEFA",
                    fetchURL: Scoreboard.Urls.euefa
                )
            }

            if enableWUEFA {
                SoccerMenu(
                    title: "Womans Champions League",
                    viewModel: wuefaVM,
                    league: "WUEFA",
                    fetchURL: Scoreboard.Urls.wuefa
                )
            }

            if enableEPL {
                SoccerMenu(
                    title: "Premier League",
                    viewModel: eplVM,
                    league: "EPL",
                    fetchURL: Scoreboard.Urls.epl
                )
            }

            if enableWEPL {
                SoccerMenu(
                    title: "Women's Super League",
                    viewModel: weplVM,
                    league: "WEPL",
                    fetchURL: Scoreboard.Urls.wepl
                )
            }

            if enableESP {
                SoccerMenu(
                    title: "La Liga",
                    viewModel: espVM,
                    league: "ESP",
                    fetchURL: Scoreboard.Urls.esp
                )
            }

            if enableGER {
                SoccerMenu(
                    title: "Budesliga",
                    viewModel: gerVM,
                    league: "GER",
                    fetchURL: Scoreboard.Urls.ger
                )
            }

            if enableITA {
                SoccerMenu(
                    title: "Serie A",
                    viewModel: itaVM,
                    league: "ITA",
                    fetchURL: Scoreboard.Urls.ita
                )
            }

            if enableMEX {
                SoccerMenu(
                    title: "Liga MX",
                    viewModel: mexVM,
                    league: "MEX",
                    fetchURL: Scoreboard.Urls.mex
                )
            }

            if enableFRA {
                SoccerMenu(
                    title: "Ligue 1",
                    viewModel: fraVM,
                    league: "FRA",
                    fetchURL: Scoreboard.Urls.fra
                )
            }

            if enableNED {
                SoccerMenu(
                    title: "Eredivisie",
                    viewModel: nedVM,
                    league: "NED",
                    fetchURL: Scoreboard.Urls.ned
                )
            }

            if enablePOR {
                SoccerMenu(
                    title: "Primeira Liga",
                    viewModel: porVM,
                    league: "POR",
                    fetchURL: Scoreboard.Urls.por
                )
            }

            if enableF1 {
                F1Menu(
                    title: "F1",
                    viewModel: f1VM,
                    league: "F1",
                    fetchURL: Scoreboard.Urls.f1
                )
            }

            if enableNC {
                RacingMenu(
                    title: "Nascar Premier",
                    viewModel: ncVM,
                    league: "NC",
                    fetchURL: Scoreboard.Urls.nc
                )
            }

            if enableNCS {
                RacingMenu(
                    title: "Nascar Secondary",
                    viewModel: ncsVM,
                    league: "NCS",
                    fetchURL: Scoreboard.Urls.ncs
                )
            }

            if enableNCT {
                RacingMenu(
                    title: "Nascar Truck",
                    viewModel: nctVM,
                    league: "NCT",
                    fetchURL: Scoreboard.Urls.nct
                )
            }

            if enableIRL {
                RacingMenu(
                    title: "IndyCar",
                    viewModel: irlVM,
                    league: "IRL",
                    fetchURL: Scoreboard.Urls.irl
                )
            }

            if enablePGA {
                GolfMenu(
                    title: "PGA",
                    viewModel: pgaVM,
                    league: "PGA",
                    fetchURL: Scoreboard.Urls.pga
                )
            }

            if enableLPGA {
                GolfMenu(
                    title: "LPGA",
                    viewModel: lpgaVM,
                    league: "LPGA",
                    fetchURL: Scoreboard.Urls.lpga
                )
            }

            if enableATP {
                TennisMenu(
                    title: "ATP Tour",
                    viewModel: atpVM,
                    league: "ATP",
                    fetchURL: Scoreboard.Urls.atp
                )
            }

            if enableWTA {
                TennisMenu(
                    title: "WTA Tour",
                    viewModel: wtaVM,
                    league: "WTA",
                    fetchURL: Scoreboard.Urls.wta
                )
            }

//            if enableUFC {
//                UFCMenu(
//                    title: "UFC",
//                    viewModel: ufcVM,
//                    league: "UFC",
//                    fetchURL: Scoreboard.Urls.ufc,
//                    currentTitle: $currentTitle,
//                    currentGameID: $currentGameID,
//                    currentGameState: $currentGameState,
//                    previousGameState: $previousGameState
//                )
//            }

            if enableNLL {
                LacrosseMenu(
                    title: "NLL",
                    viewModel: nllVM,
                    league: "NLL",
                    fetchURL: Scoreboard.Urls.nll
                )
            }

            if enablePLL {
                LacrosseMenu(
                    title: "PLL",
                    viewModel: pllVM,
                    league: "PLL",
                    fetchURL: Scoreboard.Urls.pll
                )
            }

            if enableLNCAAM {
                LacrosseMenu(
                    title: "NCAA M Lacrosse",
                    viewModel: lncaamVM,
                    league: "LNCAAM",
                    fetchURL: Scoreboard.Urls.lncaam
                )
            }

            if enableLNCAAF {
                LacrosseMenu(
                    title: "NCAA F Lacrosse",
                    viewModel: lncaafVM,
                    league: "LNCAAF",
                    fetchURL: Scoreboard.Urls.lncaaf
                )
            }

            if enableVNCAAM {
                VolleyballMenu(
                    title: "NCAA M Volleyball",
                    viewModel: vncaamVM,
                    league: "VNCAAM",
                    fetchURL: Scoreboard.Urls.vncaam
                )
            }

            if enableVNCAAF {
                VolleyballMenu(
                    title: "NCAA F Volleyball",
                    viewModel: vncaafVM,
                    league: "VNCAAF",
                    fetchURL: Scoreboard.Urls.vncaaf
                )
            }

            if enableOMIHC {
                HockeyMenu(
                    title: "Men's Olympic Ice Hcokey",
                    viewModel: omihcVM,
                    league: "OMIHC",
                    fetchURL: Scoreboard.Urls.omihc
                )
            }

            if enableOWIHC {
                HockeyMenu(
                    title: "Women's Olympic Ice Hcokey",
                    viewModel: owihcVM,
                    league: "OWIHC",
                    fetchURL: Scoreboard.Urls.owihc
                )
            }

            if enableFFWC {
                SoccerMenu(
                    title: "FIFA World Cup",
                    viewModel: ffwcVM,
                    league: "FFWC",
                    fetchURL: Scoreboard.Urls.ffwc
                )
            }

            if enableFFWWC {
                SoccerMenu(
                    title: "FIFA Women's World Cup",
                    viewModel: ffwwcVM,
                    league: "FFWWC",
                    fetchURL: Scoreboard.Urls.ffwwc
                )
            }

            if enableFFWC {
                SoccerMenu(
                    title: "FIFA World Cup UEFA Qualifiers",
                    viewModel: ffwcquefaVM,
                    league: "FFWCQUEFA",
                    fetchURL: Scoreboard.Urls.ffwcquefa
                )
            }

            if enableFFWC {
                SoccerMenu(
                    title: "FIFA World Cup CONMEBOL Qualifiers",
                    viewModel: conmebolVM,
                    league: "CONMEBOL",
                    fetchURL: Scoreboard.Urls.conmebol
                )
            }

            if enableFFWC {
                SoccerMenu(
                    title: "FIFA World Cup CONCACAF Qualifiers",
                    viewModel: concacafVM,
                    league: "CONCACAF",
                    fetchURL: Scoreboard.Urls.concacaf
                )
            }

            if enableAFC {
                SoccerMenu(
                    title: "FIFA World Cup African Qualifiers",
                    viewModel: cafVM,
                    league: "CAF",
                    fetchURL: Scoreboard.Urls.caf
                )
            }

            if enableAFC {
                SoccerMenu(
                    title: "FIFA World Cup Asian Qualifiers",
                    viewModel: afcVM,
                    league: "AFC",
                    fetchURL: Scoreboard.Urls.afc
                )
            }

            if enableOFC {
                SoccerMenu(
                    title: "FIFA World Cup Oceanian Qualifiers",
                    viewModel: ofcVM,
                    league: "OFC",
                    fetchURL: Scoreboard.Urls.ofc
                )
            }

            Divider()
                .stableMenuBarItem("menu-divider-footer")

            if enableNotch {
                Picker("Choose Display", selection: $notchScreenIndex) {
                    ForEach(NSScreen.screens.indices, id: \.self) { index in
                        Text(NSScreen.screens[index].localizedName)
                            .tag(index)
                    }
                }
                .stableMenuBarItem("menu-picker-display")
            }

            Button {
                Task {
                    await refreshAllLeagues()
                }
            } label: {
                Text("Refresh")
            }
            .keyboardShortcut("r")
            .stableMenuBarItem("menu-refresh")

            Button {
                PinnedGameState.shared.clear()

                Task {
                    if let notch = NotchViewModel.shared.notch {
                        await notch.hide()
                    }
                    NotchViewModel.shared.game = nil
                    NotchViewModel.shared.currentGameID = ""
                    NotchViewModel.shared.currentGameState = ""
                    NotchViewModel.shared.previousGameState = ""
                    NotchViewModel.shared.notch = nil
                    reconcileBackgroundRefresh()
                }
            } label: {
                Text("Clear Set Game")
            }
            .keyboardShortcut("c")
            .stableMenuBarItem("menu-clear-game")

            Divider()
                .stableMenuBarItem("menu-divider-settings")

            if #available(macOS 14, *) {
                Button {
                    let environment = EnvironmentValues()
                    environment.openSettings()
                    NSApp.setActivationPolicy(.regular)
                    NSApp.activate(ignoringOtherApps: true)
                } label: {
                    Text("Preferences")
                }
                .keyboardShortcut(",")
                .stableMenuBarItem("menu-preferences")
            }

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Text("Quit")
            }
            .keyboardShortcut("q")
            .stableMenuBarItem("menu-quit")
        } label: {
            MenuBarStatusLabel(
                onPinnedGameIDChange: {
                    syncCurrentGameDetailURL()
                    reconcileBackgroundRefresh()
                },
                onAppearAction: {
                    PinnedGameState.shared.onPinStateChanged = {
                        syncCurrentGameDetailURL()
                        reconcileBackgroundRefresh()
                    }
                    AutoMonitorHub.shared.configure(
                        isEnabled: { autoMonitorEnabled },
                        favoriteRaw: { autoMonitorFavorite },
                        enabledLeagues: { enabledLeagueCodes() },
                        eventSources: { buildScoreboardEventSources() },
                        tennisSources: { buildTennisSources() },
                        apply: { title, id, state, league in
                            PinnedGameState.shared.applyAutoMonitor(
                                title: title,
                                gameID: id,
                                state: state,
                                league: league
                            )
                            syncCurrentGameDetailURL()
                            reconcileBackgroundRefresh()
                        }
                    )
                    RefreshCoordinator.shared.configure(interval: refreshInterval) {
                        await backgroundRefreshTick()
                    }
                    reconcileBackgroundRefresh()
                    Task { await backgroundRefreshTick() }
                }
            )
            .onChange(of: autoMonitorEnabled) { enabled in
                if enabled {
                    AutoMonitorHub.shared.resetForFavoriteChange()
                }
                reconcileBackgroundRefresh()
                if enabled {
                    Task { await backgroundRefreshTick() }
                }
            }
            .onChange(of: autoMonitorFavorite) { _ in
                AutoMonitorHub.shared.resetForFavoriteChange()
                reconcileBackgroundRefresh()
                Task { await backgroundRefreshTick() }
            }
            .onChange(of: selectedOption) { _ in
                RefreshCoordinator.shared.setUserInterval(refreshInterval)
            }
        }

        Settings {
            if #available(macOS 15.0, *) {
                SettingsView()
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                    .containerBackground(.thickMaterial, for: .window)
            } else {
                SettingsView()
            }
        }

        .commands {
            CommandGroup(replacing: .help) {
                Button("MenuScores Help") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/MenuScores") {
                        NSWorkspace.shared.open(url)
                    }
                }

                Divider()

                Button("Feedback") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/MenuScores/issues/new") {
                        NSWorkspace.shared.open(url)
                    }
                }

                Button("Changelog") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/MenuScores/releases") {
                        NSWorkspace.shared.open(url)
                    }
                }

                Button("License") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/MenuScores/blob/main/License") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        }
    }
}
