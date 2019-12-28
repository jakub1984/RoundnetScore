//
//  UIView+Animations.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 27/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import UIKit

extension UIView {

  func move(to destination: CGPoint, duration: TimeInterval,
            options: UIView.AnimationOptions) {
    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
      self.center = destination
    }, completion: nil)
  }

}
