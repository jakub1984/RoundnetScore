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
    @IBOutlet weak var serverHomeAView: UIView!
    @IBOutlet weak var serverHomeBView: UIView!
    @IBOutlet weak var serverAwayAView: UIView!
    @IBOutlet weak var serverAwayBView: UIView!


    

    static let green = UIColor(red: 6, green: 195, blue: 146, alpha: 1)
    static let blue = UIColor(red: 3, green: 27, blue: 62, alpha: 1)
    static let red = UIColor(red: 218, green: 65, blue: 101, alpha: 1)
    static let white = UIColor(red: 241, green: 247, blue: 238, alpha: 1)
    static let yellow = UIColor(red: 250, green: 222, blue: 50, alpha: 1)

    private var players: [Player] = [
        Player(team: .noTeam, position: .NO),
        Player(team: .home, position: .A),
        Player(team: .away, position: .A),
        Player(team: .home, position: .B),
        Player(team: .away, position: .B)
    ]

    var viewModel = GameViewModel()

    private var homeScore: Int = 0
    private var homeSets: Int = 0

    private var awayScore: Int = 0
    private var awaySets: Int = 0

    private var setsHistory: [Score] = []
    private var scoreHistory: [Score] = []

    private var currentServer: Player = Player(team: .noTeam, position: .NO)
    private var currentReceiver: Player = Player(team: .noTeam, position: .NO)

    var maxScore: Int = 15
    var maxSets: Int = 3
    var startingTeam: Team = .noTeam
    var hardCap: Int? = nil

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

    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }

    override func viewWillAppear(_ animated: Bool) {
        nextSet()
    }

    private func newGame() {
        updateNewGameUI()
    }

    private func setPlayerBackgrounds() {
        clearAllReceiversBackground()
        switch currentServer {
        case players[1]:
            serverHomeAView.backgroundColor = .yellow
        case players[2]:
            serverAwayAView.backgroundColor = .yellow
        case players[3]:
            serverHomeBView.backgroundColor = .yellow
        case players[4]:
            serverAwayBView.backgroundColor = .yellow
        default:
            break
        }

        switch currentReceiver {
        case players[1]:
            serverHomeAView.backgroundColor = .lightGray
        case players[2]:
            serverAwayAView.backgroundColor = .lightGray
        case players[3]:
            serverHomeBView.backgroundColor = .lightGray
        case players[4]:
            serverAwayBView.backgroundColor = .lightGray
        default:
            break
        }
    }

    private func getReceiver() {

        switch currentServer {
        case players[0]:
            currentReceiver = players[0]
        case players[1]:
            currentReceiver = players[4]
        case players[2]:
            currentReceiver = players[3]
        case players[3]:
            currentReceiver = players[2]
        case players[4]:
            currentReceiver = players[1]
        default:
            break
        }
    }

    private func switchTeamReceiver() {
        switch currentReceiver.team {
        case .home:
            currentReceiver = currentReceiver == players[1] ? players[3] : players[1]
        case .away:
            currentReceiver = currentReceiver == players[2] ? players[4] : players[2]
        default:
            break
        }
    }

    private func rotateServers() {
        let destinationHomeA = serverHomeAView.convert(serverHomeAView.center, to: serverHomeAView)
        let destinationHomeB = serverHomeBView.convert(serverHomeBView.center, to: serverHomeBView)
        let destinationAwayA = serverAwayAView.convert(serverAwayAView.center, to: serverAwayAView)
        let destinationAwayB = serverAwayBView.convert(serverAwayBView.center, to: serverAwayBView)

        switch currentServer.team {
        case .home:
            serverHomeAView.move(to: destinationHomeB.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
            serverHomeBView.move(to: destinationHomeA.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
        case .away:
            serverAwayAView.move(to: destinationAwayB.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
            serverAwayBView.move(to: destinationAwayA.applying(CGAffineTransform(translationX: 0, y: 0)), duration: 0.5, options: .curveEaseInOut)
        default:
            break
        }
    }

    private func clearAllReceiversBackground() {
        serverHomeAView.backgroundColor = .white
        serverHomeBView.backgroundColor = .white
        serverAwayAView.backgroundColor = .white
        serverAwayBView.backgroundColor = .white
    }

    private func nextSet() {
        guard !setsHistory.isEmpty else { return }
        if setsHistory.count == maxSets {
            self.setsHistory.removeAll()
        }

        updateNewGameUI()
    }

    private func updateNewGameUI() {
        self.awayScore = 0
        self.homeScore = 0

        updateSets()

//        TODO: prověřit že se chová podle pravidel
        updateServer()

        self.scoreHistory = []

        self.homeScoreLbl.text = getScore(team: homeScore)
        self.awayScoreLbl.text = getScore(team: awayScore)
        self.homeSetsLbl.text = getSetsLabel(team: homeSets)
        self.awaySetsLbl.text = getSetsLabel(team: awaySets)
        self.setsConfiguartionLbl.text = getSettingsLabel()
        serveIndicatorView.center.y = settingsView.center.y
        self.serveIndicatorView.isHidden = true
        clearAllReceiversBackground()
    }

    private func updateServer() {

//        TODO: přepsat aby zahajoval set druhý tým
        if currentServer != players[0] {
            self.currentServer = currentServer.team == .away ? players[1] : players[2]
        }
    }

    private func updateSets() {
        self.homeSets = 0
        self.awaySets = 0

        setsHistory.forEach { score in
            if score.home > score.away {
                homeSets += homeSets
            } else {
                awaySets += awaySets
            }
        }
    }

    private func calculateServe() {
        if scoreHistory.isEmpty {
            currentServer = players[0]
            currentReceiver = players[0]
            clearAllReceiversBackground()
        } else {
            let previousScore = scoreHistory[scoreHistory.count - 1]
            let previousHomeScore = previousScore.home
            let previousAwayScore = previousScore.away

            if homeScore > previousHomeScore && currentServer.team == .away {
                nextServer()
                getReceiver()
                print("Serve changed to \(String(describing: currentServer.id))")

            } else if awayScore > previousAwayScore && currentServer.team == .home {
                nextServer()
                getReceiver()
                print("Serve changed to \(String(describing: currentServer.id))")

            } else {
                switchTeamReceiver()
                rotateServers()
                print("Serve stays with player \(String(describing: currentServer.id))")
            }
        }
    }

    private func previousServe() {
        guard !scoreHistory.isEmpty else { return }

            let previousScore = scoreHistory[scoreHistory.count - 1]
            let previousHomeScore = previousScore.home
            let previousAwayScore = previousScore.away

            if homeScore > previousHomeScore && currentServer.team == .away {
//                nextServer()
//                getReceiver()
                print("Serve changed to \(String(describing: currentServer.id))")

            } else if awayScore > previousAwayScore && currentServer.team == .home {
//                nextServer()
//                getReceiver()
//                print("Serve changed to \(String(describing: currentServer.id))")

            } else {
//                switchTeamReceiver()
                rotateServers()
                print("Serve stays with player \(String(describing: currentServer.id))")
            }

    }

    private func nextServer() {
        let currentServer = self.currentServer.id
        let nextId = currentServer + 1
        let nextServer = nextId == players.count ? players[1] : players[nextId]
        self.currentServer = nextServer
    }

    private func previousServer() {
        let lastScore = scoreHistory.last

        if let lastServer = lastScore?.scoringPlayer, let lastReceiver = lastScore?.receivingPlayer {
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
        let finalScore = Score(home: homeScore, away: awayScore, scoringPlayer: currentServer, currentReceiver: currentReceiver)
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
        let currentScore = Score(home: homeScore, away: awayScore, scoringPlayer: currentServer, currentReceiver: currentReceiver)
        scoreHistory.append(currentScore)
        print("Last score saved \(String(describing: scoreHistory.last))")
    }

    //    MARK: Scoring Actions
    @IBAction func homeDidScore(_ sender: UIButton) {
        if self.scoreHistory.isEmpty {
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
        if self.scoreHistory.isEmpty {
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
        previousServe()
        guard !scoreHistory.isEmpty else { return }
        scoreHistory.removeLast()
        if scoreHistory.isEmpty {
            self.currentServer = players[0]
            self.currentReceiver = players[0]
        } else {
            guard let lastScore = scoreHistory.last else { return }
            homeScore = lastScore.home
            awayScore = lastScore.away
            homeScoreLbl.text = getScore(team: homeScore)
            awayScoreLbl.text = getScore(team: awayScore)
            currentServer = lastScore.scoringPlayer ?? players[0]
            currentReceiver = lastScore.receivingPlayer ?? players[0]
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
