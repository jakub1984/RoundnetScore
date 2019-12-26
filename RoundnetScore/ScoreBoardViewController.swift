//
//  ViewController.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 26/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import UIKit

class ScoreBoardViewController: UIViewController {

//    MARK: Outlets
    @IBOutlet weak var homeAddLbl: UIButton!
    @IBOutlet weak var homeRemoveLbl: UIButton!
    @IBOutlet weak var homeScoreLbl: UILabel!

    @IBOutlet weak var awayAddLbl: UIButton!
    @IBOutlet weak var awayRemoveLbl: UIButton!
    @IBOutlet weak var awayScoreLbl: UILabel!

    private var homeScore: Int = 0
    private var awayScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


//    MARK: Scoring Actions
    @IBAction func homeDidAdd(_ sender: UIButton) {
    }

    @IBAction func homeDidRemove(_ sender: UIButton) {
    }

    @IBAction func awayDidAdd(_ sender: UIButton) {
    }

    @IBAction func awayDidRemove(_ sender: UIButton) {
    }

    @IBAction func didPressRestart(_ sender: UIBarButtonItem) {
    }
}

