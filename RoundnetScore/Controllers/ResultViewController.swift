//
//  ResultViewController.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 27/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var nextGameLbl: UIButton!
    @IBOutlet weak var setsScoreLbl: UILabel!
    @IBOutlet weak var gameScoreLbl: UILabel!
    @IBOutlet weak var setsHistoryLbl: UILabel!
    
    var viewModel: ResultViewModel

    var winner: Team = .noTeam

//    convenience init(winningTeam: Team) {
//        self.init()
//        self.winner = winningTeam
//    }

    init?(coder: NSCoder, result: ResultViewModel) {
        self.viewModel = result
        self.winner = result.winningTeam
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setup()
    }

    func setup() {
        self.resultLbl.text = winner.wins
        if winner == .home {
            view.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7647058824, blue: 0.5725490196, alpha: 1)
        } else if winner == .away {
            view.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.2549019608, blue: 0.3960784314, alpha: 1)
        }

        nextGameLbl.titleLabel?.text = viewModel.sets.count == viewModel.maxSets ? "NEW GAME" : "NEXT SET"
    }

    @IBAction func nextGameBtn(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
}
