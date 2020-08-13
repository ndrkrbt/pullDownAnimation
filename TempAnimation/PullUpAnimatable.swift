//
//  PullUpViewController.swift
//  TempAnimation
//
//  Created by Andrey on 11/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

typealias UIViewControllerWithTransition = UIViewController & TransitioningDelegateble

protocol PullUpAnimatable {
    var animatedMovingView: UIView { get }
    var showingVC: UIViewControllerWithTransition { get }
    var transitionData: PullDownTransitionData { get set }
}

extension PullUpAnimatable where Self: UIViewController {
    func configurePullUpPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePullUpGesture(_:)))
        animatedMovingView.addGestureRecognizer(panGestureRecognizer)
    }
}

extension PullUpAnimatable where Self: UIGestureRecognizerDelegate {
      func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
          if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
              return panGestureRecognizer.verticalDirection(target: panGestureRecognizer.view!) == .up
          }
          return false
      }
  }

fileprivate extension UIViewController {
    
    @objc func handlePullUpGesture(_ gesture: UIPanGestureRecognizer) {
        
        guard var vc = self as? PullUpAnimatable else {
            return
        }
        let gestureLocation = gesture.location(in: view)
        
        if gesture.state == .began {
            vc.transitionData.interactionController = UIPercentDrivenInteractiveTransition()
            vc.transitionData.lastGestureLocation = gestureLocation
            vc.transitionData.startGestureLocation = gestureLocation
            vc.showingVC.customTransitionDelegate.interactionController = vc.transitionData.interactionController
            present(vc.showingVC, animated: true)
        } else if gesture.state == .changed {
            vc.transitionData.lastGestureLocation = gestureLocation
            let deltaGesture = (vc.transitionData.startGestureLocation.y - vc.transitionData.lastGestureLocation.y) / UIScreen.main.bounds.height
            let coefficient = vc.animatedMovingView.frame.origin.y / UIScreen.main.bounds.height
            vc.transitionData.percent = deltaGesture/coefficient
            vc.transitionData.interactionController?.update(vc.transitionData.percent)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if gesture.verticalDirection(target: view) == .up {
                vc.transitionData.interactionController?.finish()
            } else if gesture.verticalDirection(target: view) == .stop && vc.transitionData.percent > 0.5 {
                vc.transitionData.interactionController?.finish()
            } else {
                vc.transitionData.interactionController?.cancel()
            }
            vc.transitionData.percent = 0
            vc.transitionData.interactionController = nil
        }
    }
}


protocol TransitioningDelegateble: class {
    var customTransitionDelegate: TransitioningDelegate { get }
}
