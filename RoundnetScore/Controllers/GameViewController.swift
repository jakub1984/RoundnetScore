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
        updateServer()

        self.scoreHistory = []

        self.homeScoreLbl.text = getScore(team: homeScore)
        self.awayScoreLbl.text = getScore(team: awayScore)
        self.homeSetsLbl.text = getSetsLabel(team: homeSets)
        self.awaySetsLbl.text = getSetsLabel(team: awaySets)
        self.setsConfiguartionLbl.text = getSettingsLabel()
        serveIndicatorView.center.y = settingsView.center.y
        self.serveIndicatorView.isHidden = true
    }

    private func updateServer() {
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
        } else {
            let previousScore = scoreHistory[scoreHistory.count - 1]
            let previousHomeScore = previousScore.home
            let previousAwayScore = previousScore.away

            if homeScore > previousHomeScore && currentServer.team == .away {
                nextServer()
                print("Serve changed to \(String(describing: currentServer.id))")

            } else if awayScore > previousAwayScore && currentServer.team == .home {
                nextServer()
                print("Serve changed to \(String(describing: currentServer.id))")

            } else {
                print("Serve stays with player \(String(describing: currentServer.id))")
            }
        }
    }

    private func nextServer() {
        let currentServer = self.currentServer.id
        let nextId = currentServer + 1
        let nextServer = nextId == players.count ? players[1] : players[nextId]
        self.currentServer = nextServer
    }

    private func previousServer() {
//        let currentServer = self.currentServer?.id ?? 1
//        let previousId = currentServer - 1
//        let previousServer = previousId == 0 ? players[4] : players[previousId]
//        self.currentServer = previousServer
//        print("Previous Server mr: \(String(describing: self.currentServer?.id))")

        guard let lastServer = scoreHistory.last?.scoringPlayer else {
            self.currentServer = players[0]
            return
        }
        self.currentServer = lastServer
        print("Previous Server mr: \(String(describing: self.currentServer.id))")

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
        let finalScore = Score(home: homeScore, away: awayScore, scoringPlayer: currentServer)
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
//        TODO: safely unwrap optional
        let finalSet = isFinalGame()

        let viewModel = ResultViewModel(server: currentServer, sets: setsHistory, final: finalSet)
        return viewModel
    }

    private func saveScoreToHistory() {
        let currentScore = Score(home: homeScore, away: awayScore, scoringPlayer: currentServer)
        scoreHistory.append(currentScore)
        print("Last score saved \(String(describing: scoreHistory.last))")
    }

    private func removeScore() {
        if !scoreHistory.isEmpty {
            scoreHistory.removeLast()
        }
    }

    //    MARK: Scoring Actions
    @IBAction func homeDidScore(_ sender: UIButton) {
        if self.scoreHistory.isEmpty {
            currentServer = players[1]
            serveIndicatorView.isHidden = false
        } else {
            homeScore += 1
            homeScoreLbl.text = getScore(team: homeScore)
            calculateServe()
            claculateWinner()
            print("Scored mr: \(String(describing: currentServer.id))")
        }
        saveScoreToHistory()
    }

    @IBAction func awayDidScore(_ sender: UIButton) {
        if self.scoreHistory.isEmpty {
            currentServer = players[2]
            serveIndicatorView.isHidden = false
        } else {
            awayScore += 1
            awayScoreLbl.text = getScore(team: awayScore)
            calculateServe()
            claculateWinner()
            print("Scored mr: \(String(describing: currentServer.id))")
        }
        saveScoreToHistory()
    }

    @IBAction func homeDidRemove(_ sender: UIButton) {
        if homeScore == 0 && awayScore == 0 {
            removeScore()
            self.currentServer = players[0]
        }

        if homeScore > 0 {
            homeScore -= 1
            homeScoreLbl.text = getScore(team: homeScore)
            removeScore()
            previousServer()
        }
    }

    @IBAction func awayDidRemove(_ sender: UIButton) {
        if homeScore == 0 && awayScore == 0 {
            removeScore()
            self.currentServer = players[0]
        }

        if awayScore > 0 {
            awayScore -= 1
            awayScoreLbl.text = getScore(team: awayScore)
            removeScore()
            previousServer()
        }
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
