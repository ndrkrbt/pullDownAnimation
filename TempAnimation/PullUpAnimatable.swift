//
//  PullUpViewController.swift
//  TempAnimation
//
//  Created by Andrey on 11/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

protocol PullUpAnimatable {
    var animatedMovingView: UIView { get }
    var secondVC: UIViewController & TransitioningDelegateble { get }
    var interactionController: UIPercentDrivenInteractiveTransition? {get set}
    var lastGestureLocation: CGPoint {get set}
    var startGestureLocation: CGPoint {get set}
    var percent: CGFloat { get set }
}

extension PullUpAnimatable where Self: UIViewController {
    func configurePan() {
        let panDown = UIPanGestureRecognizer(target: self, action: #selector(handlePullUpGesture(_:)))
        animatedMovingView.addGestureRecognizer(panDown)
    }
}

extension PullUpAnimatable where Self: UIGestureRecognizerDelegate {
      func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
          if let pan = gestureRecognizer as? UIPanGestureRecognizer {
              return pan.verticalDirection(target: pan.view!) == .up
          }
          return false
      }
  }

fileprivate extension UIViewController {
    
    @objc func handlePullUpGesture(_ gesture: UIPanGestureRecognizer) {
        
        guard var current = self as? PullUpAnimatable else {
            return
        }
        let gestureLocation = gesture.location(in: view)
        
        if gesture.state == .began {
            current.interactionController = UIPercentDrivenInteractiveTransition()
            current.lastGestureLocation = gestureLocation
            current.startGestureLocation = gestureLocation
            current.secondVC.customTransitionDelegate.interactionController = current.interactionController
            present(current.secondVC, animated: true)
        } else if gesture.state == .changed {
            current.lastGestureLocation = gestureLocation
            let deltaGesture = (current.startGestureLocation.y - current.lastGestureLocation.y) / UIScreen.main.bounds.height
            let coefficient = current.animatedMovingView.frame.origin.y / UIScreen.main.bounds.height
            current.percent = deltaGesture/coefficient
            print(current.percent)
            current.interactionController?.update(current.percent)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if gesture.verticalDirection(target: view) == .up {
                current.interactionController?.finish()
            } else if gesture.verticalDirection(target: view) == .stop && current.percent > 0.5 {
                current.interactionController?.finish()
            } else {
                current.interactionController?.cancel()
            }
            current.percent = 0
            current.interactionController = nil
        }
    }
}


protocol TransitioningDelegateble: class {
    var customTransitionDelegate: TransitioningDelegate { get }
}

extension TransitioningDelegateble where Self: UIViewController {
    
}
