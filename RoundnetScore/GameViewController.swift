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

    private var homeScore: Int = 0
    private var homeSets: Int = 0

    private var awayScore: Int = 0
    private var awaySets: Int = 0

    var serveHistory: [Int] = []

    var maxScore: Int = 15
    var maxSets: Int = 3
    var startingTeam: Int = 0

    private var currentSet: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }

    private func calculateServe() {
        if serveHistory.count < 2 {
            print("Zahajujeme")
            serveIndicatorView.center.y = settingsView.center.y
            serveIndicatorView.isHidden = true
        } else {
            let previousServe = serveHistory[serveHistory.count - 2]

            print("previousServe \(previousServe)")

            if previousServe == 0 {
//                TODO: Verify that properly saves starting team
                startingTeam = serveHistory.last ?? 0
                self.setStartingServePosition()
                print("zahajuje tym \(serveHistory.last)")
            } else if serveHistory.last != previousServe {
                UIView.animate(withDuration: 0.5) {
                    self.setServingTeam()
                }
                print("Podání zůstává u \(serveHistory.last)")
            } else {
                print("serving team (\(serveHistory.last)")
            }
            serveIndicatorView.isHidden = false
        }
    }

    private func newGame() {
        self.awayScore = 0
        self.homeScore = 0
        self.currentSet = 1
        self.homeSets = 0
        self.awaySets = 0
        self.serveHistory = [0]

        self.homeScoreLbl.text = getScore(team: homeScore)
        self.awayScoreLbl.text = getScore(team: awayScore)
        self.homeSetsLbl.text = getSetsLabel(team: homeSets)
        self.awaySetsLbl.text = getSetsLabel(team: awaySets)
        self.setsConfiguartionLbl.text = getSettingsLabel()
        serveIndicatorView.center.y = settingsView.center.y
        self.serveIndicatorView.isHidden = true
    }

    private func setStartingServer() {

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
        if homeScore > (maxScore - 1), homeScore > (awayScore + 1) {
            print("home wins")
        } else if awayScore > (maxScore - 1), awayScore > (homeScore + 1) {
            print("away wins")
        } else {
            print("next point")
        }
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
        serveHistory.append(1)
        calculateServe()
    }

    @IBAction func awayDidScore(_ sender: UIButton) {
        awayScore += 1
        awayScoreLbl.text = getScore(team: awayScore)
        serveHistory.append(2)
        calculateServe()
    }

    @IBAction func homeDidRemove(_ sender: UIButton) {
        guard homeScore > 0 else { return }

        homeScore -= 1
        homeScoreLbl.text = getScore(team: homeScore)
        removeServe()
    }

    @IBAction func awayDidRemove(_ sender: UIButton) {
        guard awayScore > 0 else { return }

        awayScore -= 1
        awayScoreLbl.text = getScore(team: awayScore)
        removeServe()
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
