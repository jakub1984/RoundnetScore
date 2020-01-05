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

    private var homeScore: Int = 0
    private var homeSets: Int = 0

    private var awayScore: Int = 0
    private var awaySets: Int = 0

    private var serveHistory: [Int] = [0]
    private var setsHistory: [Score] = []
    private var scoreHistory: [Score] = []

    private var currentServer: Player? = Player(team: .noTeam, position: .NO)

    var maxScore: Int = 15
    var maxSets: Int = 3
    var startingTeam: Team = .noTeam

    private var currentSet: Int = 1

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

//    override func viewWillAppear(_ animated: Bool) {
//        newGame()
//    }

    private func newGame() {
        self.awayScore = 0
        self.homeScore = 0
        self.currentSet = 1
        self.homeSets = 0
        self.awaySets = 0
        self.scoreHistory = []
        self.currentServer = players[0]

        self.homeScoreLbl.text = getScore(team: homeScore)
        self.awayScoreLbl.text = getScore(team: awayScore)
        self.homeSetsLbl.text = getSetsLabel(team: homeSets)
        self.awaySetsLbl.text = getSetsLabel(team: awaySets)
        self.setsConfiguartionLbl.text = getSettingsLabel()
        serveIndicatorView.center.y = settingsView.center.y
        self.serveIndicatorView.isHidden = true
    }

    private func calculateServe() {
        if scoreHistory.isEmpty {
            currentServer = players[0]
//        } else if scoreHistory.count == 1 {
//            currentServer = homeScore > awayScore ? players[1] : players[2]
        } else {
            let previousScore = scoreHistory[scoreHistory.count - 1]
            let previousHomeScore = previousScore.home
            let previousAwayScore = previousScore.away

            if homeScore > previousHomeScore && currentServer?.team == .away {
                nextServer()
                print("Serve changed to \(String(describing: currentServer?.id))")

            } else if awayScore > previousAwayScore && currentServer?.team == .home {
                nextServer()
                print("Serve changed to \(String(describing: currentServer?.id))")

            } else {
                print("Serve stays with player \(String(describing: currentServer?.id))")
            }
        }
    }

    private func nextServer() {
        let currentServer = self.currentServer?.id ?? 0
        let nextId = currentServer + 1
        let nextServer = nextId == players.count ? players[1] : players[nextId]
        self.currentServer = nextServer
    }

    private func claculateWinner() {
        if homeScore > (maxScore - 1), homeScore > (awayScore + 1) {
            wins(team: .home)
        } else if awayScore > (maxScore - 1), awayScore > (homeScore + 1) {
            wins(team: .away)
            print("away wins")
        }
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
        let label = maxSets == 1 ? "First to \(maxScore) points win" : "Set \(currentSet) of \(maxSets) | \(maxScore) points win"
        return label
    }

    func wins(team: Team) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ResultViewController", creator: { coder in
            let vm = self.getResultViewModel()
            return ResultViewController(coder: coder, result: vm)
        }) else {
            fatalError("Failed to load ResultViewController from storyboard.")
        }

//        vc.modalPresentationStyle = .overCurrentContext
//        present(vc, animated: true, completion: nil)

        navigationController?.pushViewController(vc, animated: true)
    }

    func getResultViewModel() -> ResultViewModel {
//        TODO: safely unwrap optional
        return ResultViewModel(server: currentServer!, scores: scoreHistory)
    }

    private func saveScoreToHistory() {
        let currentScore = Score(home: homeScore, away: awayScore, scoringPlayer: currentServer)
        scoreHistory.append(currentScore)
        print("Last score saved \(String(describing: scoreHistory.last))")
    }

    private func removeServe() {
//        if serveHistory.count > 1 {
//            serveHistory.removeLast()
//        }
        if !scoreHistory.isEmpty {
            scoreHistory.removeLast()
        }
        calculateServe()
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
            print("Scored mr: \(String(describing: currentServer?.id))")
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
            print("Scored mr: \(String(describing: currentServer?.id))")
        }
        saveScoreToHistory()
    }

    @IBAction func homeDidRemove(_ sender: UIButton) {
        guard homeScore > 0 else { return }

        homeScore -= 1
        homeScoreLbl.text = getScore(team: homeScore)
        removeServe()
        calculateServe()
    }

    @IBAction func awayDidRemove(_ sender: UIButton) {
        guard awayScore > 0 else { return }

        awayScore -= 1
        awayScoreLbl.text = getScore(team: awayScore)
        removeServe()
        calculateServe()
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
        let label = maxSets == 1 ? "" : "Wins: \(team)"
        return label
    }
}
