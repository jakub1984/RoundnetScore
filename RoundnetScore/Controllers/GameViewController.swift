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

    private let players: [Player] = [
        Player(team: .noTeam),
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

    private var currentServer: Player? = nil

    var maxScore: Int = 15
    var maxSets: Int = 3
    var startingTeam: Team = .noTeam

    private var currentSet: Int = 1

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
        self.serveHistory = [0]
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
        if serveHistory.count <= 1 {
            print("Zahajujeme")
            serveIndicatorView.center.y = settingsView.center.y
            serveIndicatorView.isHidden = true
        } else {
            let previousServe = serveHistory[serveHistory.count - 2]


            if previousServe == 0 {
                self.setStartingServePosition()
                self.currentServer = self.players[1]
                print("zahajuje tym \(String(describing: serveHistory.last))")
            } else if serveHistory.last != previousServe {
                self.currentServer = self.players[1]

                UIView.animate(withDuration: 0.5) {
                    self.setServingTeam()
                }
                print("Podává \(String(describing: serveHistory.last))")
            } else {
                print("Podání zůstává u \(String(describing: serveHistory.last))")
            }
            serveIndicatorView.isHidden = false
        }
    }

    private func setStartingServePosition() {
        if serveHistory.last == 1 {
            serveIndicatorView.center.y -= 75
        } else if serveHistory.last == 2 {
            serveIndicatorView.center.y += 75
        }
    }

    private func setServingTeam() {
        if serveHistory.last == 1 {
            serveIndicatorView.center.y = settingsView.center.y - 75
        } else if serveHistory.last == 2 {
            serveIndicatorView.center.y = settingsView.center.y + 75
        }
    }

    private func getSettingsLabel() -> String {
        let label = maxSets == 1 ? "First to \(maxScore) points win" : "Set \(currentSet) of \(maxSets) | \(maxScore) points win"
        return label
    }

    private func calculateScore() {
        let currentScore = Score(home: homeScore, away: awayScore, scoringPlayer: currentServer)
        scoreHistory.append(currentScore)
        print("scoreHistory \(String(describing: scoreHistory.last))")

        if homeScore > (maxScore - 1), homeScore > (awayScore + 1) {
            wins(team: .home)

        } else if awayScore > (maxScore - 1), awayScore > (homeScore + 1) {

            wins(team: .away)
            print("away wins")
        } else {
            print("next point")
        }
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
        return ResultViewModel(server: currentServer!, scores: scoreHistory)
    }


    private func removeServe() {
        if serveHistory.count > 1 {
            serveHistory.removeLast()
        }
        calculateServe()
    }

    //    MARK: Scoring Actions
    @IBAction func homeDidScore(_ sender: UIButton) {
        homeScore += 1
        homeScoreLbl.text = getScore(team: homeScore)
        calculateServe()
        calculateScore()
    }

    @IBAction func awayDidScore(_ sender: UIButton) {
        awayScore += 1
        awayScoreLbl.text = getScore(team: awayScore)
        serveHistory.append(2)
        calculateServe()
        calculateScore()
    }

    @IBAction func homeDidRemove(_ sender: UIButton) {
        guard homeScore > 0 else { return }

        homeScore -= 1
        homeScoreLbl.text = getScore(team: homeScore)
        scoreHistory.removeLast()
        removeServe()
        calculateServe()
    }

    @IBAction func awayDidRemove(_ sender: UIButton) {
        guard awayScore > 0 else { return }

        awayScore -= 1
        awayScoreLbl.text = getScore(team: awayScore)
        scoreHistory.removeLast()
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
