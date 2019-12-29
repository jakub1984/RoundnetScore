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

    var winner: Team = .noTeam

//    convenience init(winningTeam: Team) {
//        self.init()
//        self.winner = winningTeam
//    }

    init?(coder: NSCoder, result: ResultViewModel) {
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
            view.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else if winner == .away {
            view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }

    @IBAction func nextGameBtn(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
}
