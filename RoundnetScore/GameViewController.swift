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

    private var homeScore: Int = 0
    private var homeSets: Int = 0

    private var awayScore: Int = 0
    private var awaySets: Int = 0

    var maxScore: Int = 15
    var maxSets: Int = 3
    private var currentSet: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()

    }

    private func newGame() {
        self.awayScore = 0
        self.homeScore = 0
        self.currentSet = 1
        self.homeSets = 0
        self.awaySets = 0

        self.homeScoreLbl.text = getScore(team: homeScore)
        self.awayScoreLbl.text = getScore(team: awayScore)
        self.homeSetsLbl.text = getSetsLabel(team: homeSets)
        self.awaySetsLbl.text = getSetsLabel(team: awaySets)
        self.setsConfiguartionLbl.text = getSettingsLabel()
    }

    private func getSettingsLabel() -> String {
        let label = maxSets == 1 ? "First to \(maxScore) points win" : "Set \(currentSet) of \(maxSets) | \(maxScore) points win"
        return label
    }

    //    MARK: Scoring Actions
    @IBAction func homeDidScore(_ sender: UIButton) {
        if homeScore < maxScore {
            homeScore += 1
            homeScoreLbl.text = getScore(team: homeScore)
        }
    }

    @IBAction func awayDidScore(_ sender: UIButton) {
        if awayScore < maxScore {
            awayScore += 1
            awayScoreLbl.text = getScore(team: awayScore)
        }
    }

    @IBAction func homeDidRemove(_ sender: UIButton) {
        if homeScore > 0 {
            homeScore -= 1
            homeScoreLbl.text = getScore(team: homeScore)
        }
    }

    @IBAction func awayDidRemove(_ sender: UIButton) {
        if awayScore > 0 {
            awayScore -= 1
            awayScoreLbl.text = getScore(team: awayScore)
        }
    }

    @IBAction func didPressRestart(_ sender: UIBarButtonItem) {
        newGame()
    }
    
    @IBAction func didPressEdit(_ sender: UIBarButtonItem) {
    }
}

extension GameViewController {
    func getScore(team: Int) -> String {
        return "\(team)"
    }

    func getSetsLabel(team: Int) -> String {
        let label = maxSets == 1 ? "" : "Wins: \(team)"
        return label
    }
}
