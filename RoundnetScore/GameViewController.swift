//
//  GameViewController.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 26/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

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
    var maxSets: Int = 1

    private var currentSet: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.homeScoreLbl.text = getScore(team: homeScore)
        self.awayScoreLbl.text = getScore(team: awayScore)
        self.setsConfiguartionLbl.text = getSettingsLabel()

    }

    func getSettingsLabel() -> String {
        return "Set \(currentSet) of \(maxSets) | \(maxScore) points win"
    }
    
    @IBAction func homeDidScore(_ sender: UIButton) {
    }

    @IBAction func awayDidScore(_ sender: UIButton) {
    }

    @IBAction func homeDidRemove(_ sender: UIButton) {
    }

    @IBAction func awayDidRemove(_ sender: UIButton) {
    }

    @IBAction func didPressRestart(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func didPressEdit(_ sender: UIBarButtonItem) {
    }
    
}

extension GameViewController {
    func getScore(team: Int) -> String {
        return "\(team)"
    }
}
