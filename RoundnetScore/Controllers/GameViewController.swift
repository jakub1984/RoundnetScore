//
//  GameViewController.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 26/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    //    MARK: Outlets
    @IBOutlet weak var homeScoreLbl: UILabel!
    @IBOutlet weak var awayScoreLbl: UILabel!
    @IBOutlet weak var setsConfiguartionLbl: UILabel!
    @IBOutlet weak var homeSetsLbl: UILabel!
    @IBOutlet weak var awaySetsLbl: UILabel!

    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var serveIndicatorView: UIImageView!
    @IBOutlet weak var positionAView: UIView!
    @IBOutlet weak var positionCView: UIView!
    @IBOutlet weak var positionBView: UIView!
    @IBOutlet weak var positionDView: UIView!

    static let green = UIColor(red: 6, green: 195, blue: 146, alpha: 1)
    static let blue = UIColor(red: 3, green: 27, blue: 62, alpha: 1)
    static let red = UIColor(red: 218, green: 65, blue: 101, alpha: 1)
    static let white = UIColor(red: 241, green: 247, blue: 238, alpha: 1)
    static let yellow = UIColor(red: 250, green: 222, blue: 50, alpha: 1)

    private var players: [Player] = []
    var destinationHomeA: CGPoint = CGPoint(x: 0, y: 0)
    var destinationHomeB: CGPoint = CGPoint(x: 0, y: 0)
    var destinationAwayA: CGPoint = CGPoint(x: 0, y: 0)
    var destinationAwayB: CGPoint = CGPoint(x: 0, y: 0)

    let viewModel: GameSetupModel!
    let persistenceManager: PersistenceManager!

    private var homeScore: Int = 0
    private var homeSets: Int = 0

    private var awayScore: Int = 0
    private var awaySets: Int = 0

    private var setsHistory: [Point] = []
//    private var scoreHistory: [Point] = []
    private var scores = ScoresDoublyLinkedList()

    private var currentServer: Player!
    private var currentReceiver: Player!

    private var isHomeSwitched: Bool = false
    private var isAwaySwitched: Bool = false
    private var lastStartingServer: Player!

    var maxScore: Int = 15
    var maxSets: Int = 3
    var startingTeam: Team = .noTeam

//    convenience init() {
//        self.init()
//
//        self.players = [
//            Player(team: .noTeam, position: .NO),
//            Player(team: .home, position: .A),
//            Player(team: .away, position: .A),
//            Player(team: .home, position: .B),
//            Player(team: .away, position: .B)
//        ]
//        self.currentServer = players[0]
////        newGame()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) is not supported")
//    }

    init?(coder: NSCoder, viewModel: GameSetupModel, persistenceManager: PersistenceManager) {
        self.viewModel = viewModel
        self.persistenceManager = persistenceManager
        self.players = viewModel.players
        self.currentServer = players[0]
        self.currentReceiver = players[0]
        self.lastStartingServer = players[0]
        self.maxScore = viewModel.maxPoints
        self.maxSets = viewModel.numberOfSets
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        self.persistenceManager = nil
        super.init(coder: coder)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.destinationHomeA = positionAView.convert(positionAView.center, to: positionAView)
        self.destinationHomeB = positionCView.convert(positionCView.center, to: positionCView)
        self.destinationAwayA = positionBView.convert(positionBView.center, to: positionBView)
        self.destinationAwayB = positionDView.convert(positionDView.center, to: positionDView)
        newGame()
        print("ViewModel: \(String(describing: self.viewModel))")
    }

    override func viewWillAppear(_ animated: Bool) {
        nextSet()
    }

    private func newGame() {
        setNewGameUI()
        scores.deleteAll()
    }

    private func setPlayerBackgrounds() {
        clearAllReceiversBackground()
        switch currentServer {
        case players[1]:
            positionAView.backgroundColor = .yellow
        case players[2]:
            positionBView.backgroundColor = .yellow
        case players[3]:
            positionCView.backgroundColor = .yellow
        case players[4]:
            positionDView.backgroundColor = .yellow
        default:
            break
        }

        switch currentReceiver {
        case players[1]:
            positionAView.backgroundColor = .lightGray
        case players[2]:
            positionBView.backgroundColor = .lightGray
        case players[3]:
            positionCView.backgroundColor = .lightGray
        case players[4]:
            positionDView.backgroundColor = .lightGray
        default:
            break
        }
    }

    private func setCurrentReceiver() {
        currentReceiver = getReceiver(serverPosition: currentServer.position)
    }

//    extrahovat do viewModelu
    private func getReceiver(serverPosition: Position) -> Player {
        switch serverPosition {
        case .NO:
            return players[0]
        case .A:
            return getPlayerAtPosition(.D)
        case .B:
            return getPlayerAtPosition(.C)
        case .C:
            return getPlayerAtPosition(.B)
        case .D:
            return getPlayerAtPosition(.A)
        }
    }

    private func getPlayerAtPosition(_ position: Position) -> Player {
//        players.forEach { player in
//            if player.position == position { return player }
//        }
        print("currentServer \(currentServer)")


        return players.filter { $0.position == position }.first ?? players[0]
    }

//    private func switchTeamReceiver() {
//        switch currentReceiver.team {
//        case .home:
//            currentReceiver = currentReceiver == players[1] ? players[3] : players[1]
//            isAwaySwitched = isAwaySwitched ? false : true
//        case .away:
//            currentReceiver = currentReceiver == players[2] ? players[4] : players[2]
//            isHomeSwitched = isHomeSwitched ? false : true
//        default:
//            break
//        }
//    }

    private func rotateServers() {
        let destinationHomeA = positionAView.convert(positionAView.center, to: positionAView)
        let destinationHomeB = positionCView.convert(positionCView.center, to: positionCView)
        let destinationAwayA = positionBView.convert(positionBView.center, to: positionBView)
        let destinationAwayB = positionDView.convert(positionDView.center, to: positionDView)

        switch currentServer.team {
        case .home:
            positionAView.move(to: destinationHomeB.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
            positionCView.move(to: destinationHomeA.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
        case .away:
            positionBView.move(to: destinationAwayB.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
            positionDView.move(to: destinationAwayA.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
        default:
            break
        }

        switchServerPositions()
    }

    private func resetPlayersPositions() {
        if isHomeSwitched {
            positionAView.move(to: self.destinationHomeA.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
            positionCView.move(to: self.destinationHomeB.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
        }

        if isAwaySwitched {
            positionBView.move(to: self.destinationAwayA.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
            positionDView.move(to: self.destinationAwayB.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
        }
        isHomeSwitched = false
        isAwaySwitched = false
        switchServerPositions()
    }

    private func switchServerPositions() {
        print("currentServer \(currentServer)")

        switch currentServer.team {
        case .home:
            if players[1].position == .A {
                players[1].position = .C
                players[3].position = .A
                isHomeSwitched = true
            } else {
                players[1].position = .A
                players[3].position = .C
                isHomeSwitched = false
            }
        case .away:
            if players[2].position == .B {
                players[2].position = .D
                players[4].position = .B
                isAwaySwitched = true
            } else {
                players[2].position = .B
                players[4].position = .D
                isAwaySwitched = false
            }
        case .noTeam:
            players[1].position = .A
            players[2].position = .B
            players[3].position = .C
            players[4].position = .D
        }

        currentServer = players[currentServer.id]
    }

    private func clearAllReceiversBackground() {
        positionAView.backgroundColor = .white
        positionCView.backgroundColor = .white
        positionBView.backgroundColor = .white
        positionDView.backgroundColor = .white
    }

    private func nextSet() {
        guard !setsHistory.isEmpty else { return }
        if setsHistory.count == maxSets {
            self.setsHistory.removeAll()
        }

        setNewGameUI()
    }

    private func setNewGameUI() {
        let savedPlayers = persistenceManager.fetch(PlayerCoreData.self)

        self.awayScore = 0
        self.homeScore = 0

        updateSets()

        setStartingServer()
        setStartingReceiver()
        resetPlayersPositions()
        clearAllReceiversBackground()

        self.scores.deleteAll()

        self.homeScoreLbl.text = getScore(team: homeScore)
        self.awayScoreLbl.text = getScore(team: awayScore)
        self.homeSetsLbl.text = getSetsLabel(team: homeSets)
        self.awaySetsLbl.text = getSetsLabel(team: awaySets)
        self.setsConfiguartionLbl.text = getSettingsLabel()
        serveIndicatorView.center.y = settingsView.center.y
        self.serveIndicatorView.isHidden = true
    }

    private func setStartingServer() {
//        TODO: přepsat aby zahajoval set druhý tým
        self.currentServer = players[0]

//        if currentServer != players[0] {
//            self.currentServer = currentServer.team == .away ? players[1] : players[2]
//        }
    }

    private func setStartingReceiver() {
        self.currentReceiver = players[0]
    }

    private func updateSets() {
        self.homeSets = 0
        self.awaySets = 0

        setsHistory.forEach { score in
            if score.home > score.away {
                homeSets += 1
            } else {
                awaySets += 1
            }
        }
    }

    private func calculateServe() {
        guard let previousScore = scores.tail?.value else {
            currentServer = players[0]
            currentReceiver = players[0]
            clearAllReceiversBackground()
            return
        }

        let previousHomeScore = previousScore.home
        let previousAwayScore = previousScore.away

        if homeScore > previousHomeScore && currentServer.team == .away {
            nextServer()
            setCurrentReceiver()
            print("Serve changed to \(String(describing: currentServer.id))")

        } else if awayScore > previousAwayScore && currentServer.team == .home {
            nextServer()
            setCurrentReceiver()
            print("Serve changed to \(String(describing: currentServer.id))")

        } else {
            rotateServers()
            setCurrentReceiver()

            print("Serve stays with player \(String(describing: currentServer.id))")
        }
    }

    private func previousServe() {
        guard let previousScore = scores.tail?.value else { return }
        guard let previousServerTeam = previousScore.server?.team else { return }
        let previousHomeScore = previousScore.home
        let previousAwayScore = previousScore.away

        if homeScore > previousHomeScore && previousServerTeam == .away {
            switchServerPositions()
        } else if awayScore > previousAwayScore && previousServerTeam == .home {
            switchServerPositions()
        } else {
            rotateServers()
        }
    }

    private func nextServer() {
        let currentServerId = self.currentServer.id
        let nextId = currentServerId + 1
        let nextServer = nextId == players.count ? players[1] : players[nextId]
        self.currentServer = nextServer
    }

    private func previousServer() {
//        let lastScore = scoreHistory.last
        let lastScore = scores.tail

        if let lastServer = lastScore?.value.receiver, let lastReceiver = lastScore?.value.receiver {
            self.currentServer = lastServer
            self.currentReceiver = lastReceiver
        } else {
            self.currentServer = players[0]
            self.currentReceiver = players[0]
        }

        setPlayerBackgrounds()
    }

    private func claculateWinner() {
        if homeScore > (maxScore - 1), homeScore > (awayScore + 1) {
            saveFinalScore()
            wins(team: .home)
        } else if awayScore > (maxScore - 1), awayScore > (homeScore + 1) {
            saveFinalScore()
            wins(team: .away)
        }
    }

    private func isFinalGame() -> Bool {
        if maxSets == 1,
            homeSets > awaySets + 1 && homeSets > maxSets / 2,
            awaySets > homeSets + 1 && awaySets > maxSets / 2 {
            return true
        } else {
            return false
        }
    }

    private func saveFinalScore() {
        let finalScore = Point(home: homeScore, away: awayScore, currentServer: currentServer, currentReceiver: currentReceiver)
        setsHistory.append(finalScore)
    }

//    private func setStartingServePosition() {
//        if serveHistory.last == 1 {
//            serveIndicatorView.center.y -= 75
//        } else if serveHistory.last == 2 {
//            serveIndicatorView.center.y += 75
//        }
//    }
//
//    private func setServingTeam() {
//        if serveHistory.last == 1 {
//            serveIndicatorView.center.y = settingsView.center.y - 75
//        } else if serveHistory.last == 2 {
//            serveIndicatorView.center.y = settingsView.center.y + 75
//        }
//    }

    private func getSettingsLabel() -> String {
        let label = maxSets == 1 ? "First to \(maxScore) points win" : "Set \(setsHistory.count) of \(maxSets) | \(maxScore) points win"
        return label
    }

    func wins(team: Team) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ResultViewController", creator: { coder in
            let vm = self.getResultViewModel()
            return ResultViewController(coder: coder, result: vm)
        }) else {
            fatalError("Failed to load ResultViewController from storyboard.")
        }

        navigationController?.pushViewController(vc, animated: false)
    }

    func getResultViewModel() -> ResultViewModel {
        let finalSet = isFinalGame()

        let viewModel = ResultViewModel(server: currentServer, sets: setsHistory, final: finalSet)
        return viewModel
    }

    private func saveScoreToHistory() {
        let currentScore = Point(home: homeScore, away: awayScore, currentServer: currentServer, currentReceiver: currentReceiver)
        scores.append(currentScore)
    }

    //    MARK: Scoring Actions
    @IBAction func homeDidScore(_ sender: UIButton) {
        if scores.tail == nil {
            currentServer = players[1]
//            serveIndicatorView.isHidden = false
            currentReceiver = players[4]
        } else {
            homeScore += 1
            homeScoreLbl.text = getScore(team: homeScore)
            calculateServe()
            claculateWinner()
            print("Scored mr: \(String(describing: currentServer.id))")
        }
        setPlayerBackgrounds()
        saveScoreToHistory()
    }

    @IBAction func awayDidScore(_ sender: UIButton) {
        if scores.tail == nil {
            currentServer = players[2]
            currentReceiver = players[3]
//            serveIndicatorView.isHidden = false
        } else {
            awayScore += 1
            awayScoreLbl.text = getScore(team: awayScore)
            calculateServe()
            claculateWinner()
            print("Scored mr: \(String(describing: currentServer.id))")
        }
        setPlayerBackgrounds()
        saveScoreToHistory()
    }

    @IBAction func homeDidRemove(_ sender: UIButton) {
//        guard scores.tail != nil else { return }
        scores.deleteLast()
        previousServe()

        if scores.tail == nil {
            setNewGameUI()
        } else {
            guard let lastScore = scores.tail?.value else { return }
            homeScore = lastScore.home
            awayScore = lastScore.away
            homeScoreLbl.text = getScore(team: homeScore)
            awayScoreLbl.text = getScore(team: awayScore)
            currentServer = lastScore.server ?? players[0]
            currentReceiver = lastScore.receiver ?? players[0]
        }
//        TODO: fix rotating users when remove the score

        setPlayerBackgrounds()
    }

    @IBAction func awayDidRemove(_ sender: UIButton) {

    }

    @IBAction func didPressRestart(_ sender: UIBarButtonItem) {
        newGame()
    }
    
    @IBAction func didPressEdit(_ sender: UIBarButtonItem) {
    }
}

// MARK: Extensions

extension GameViewController {
    func getScore(team: Int) -> String {
        return "\(team)"
    }

    func getSetsLabel(team: Int) -> String {
        let label = maxSets == 1 ? "" : "Sets: \(team)"
        return label
    }
}
