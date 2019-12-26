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
    @IBOutlet weak var homeAdd: UIButton!
    @IBOutlet weak var homeRemove: UIButton!
    @IBOutlet weak var homeScore: UILabel!

    @IBOutlet weak var awayAdd: UIButton!
    @IBOutlet weak var awayRemove: UIButton!
    @IBOutlet weak var awayScore: UILabel!


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

}

