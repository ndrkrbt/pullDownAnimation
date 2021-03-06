//
//  PullDownAnimatable.swift
//  TempAnimation
//
//  Created by Andrey on 13/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

protocol PullDownAnimatable {
    var animatedMovingView: UIView { get }
    var transitionData: PullDownTransitionData { get set }
}

struct PullDownTransitionData {
    var interactionController: UIPercentDrivenInteractiveTransition?
    var lastGestureLocation: CGPoint
    var startGestureLocation: CGPoint
    var percent: CGFloat
    var isPercentDriven: Bool
    
    init(isPercentDriven: Bool) {
        self.interactionController = nil
        self.lastGestureLocation = .zero
        self.startGestureLocation = .zero
        self.percent = 0
        self.isPercentDriven = isPercentDriven
    }
}

extension PullDownAnimatable where Self: UIViewController {
  func configureRecognizers(){
        configurePullDownPanGestureRecognizer()
        configurePullDownTapGestureRecognizer()
    }
    
    func configurePullDownPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePullDownPanGesture))
        animatedMovingView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func configurePullDownTapGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePullDownTapGesture))
        animatedMovingView.addGestureRecognizer(tapGestureRecognizer)
    }
}

extension PullDownAnimatable where Self: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            return panGestureRecognizer.verticalDirection(target: panGestureRecognizer.view!) == .down
        }
        return false
    }
}

fileprivate extension UIViewController {
    
    @objc func handlePullDownTapGesture(_ gesture: UITapGestureRecognizer) {
        guard var vc = self as? PullDownAnimatable & TransitioningDelegateble else {
            return
        }
        vc.transitionData.interactionController = UIPercentDrivenInteractiveTransition()
        vc.customTransitionDelegate.interactionController = vc.transitionData.interactionController
        dismiss(animated: true)
        vc.transitionData.interactionController?.finish()
    }
    
    @objc func handlePullDownPanGesture(_ gesture: UIPanGestureRecognizer) {
        guard var vc = self as? PullDownAnimatable & TransitioningDelegateble else {
            return
        }
        
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let gestureLocation = gesture.location(in: view)
        
        if gesture.state == .began {
            vc.transitionData.lastGestureLocation = gestureLocation
            vc.transitionData.startGestureLocation = gestureLocation
            vc.transitionData.interactionController = UIPercentDrivenInteractiveTransition()
            vc.customTransitionDelegate.interactionController = vc.transitionData.interactionController
            dismiss(animated: true)
        } else if gesture.state == .changed {
            guard vc.transitionData.isPercentDriven else {
                return
            }
            vc.transitionData.lastGestureLocation = gestureLocation
            let changebleViewHeight = screenHeight - self.view.frame.origin.y
            let modifiedPercent = (self.view.frame.origin.y + vc.transitionData.lastGestureLocation.y - vc.transitionData.startGestureLocation.y)/screenHeight
            vc.transitionData.percent = modifiedPercent/(1 - changebleViewHeight/screenHeight)
            vc.transitionData.interactionController?.update(vc.transitionData.percent)
        } else if gesture.state == .ended {
            if vc.transitionData.percent > 0.5 && gesture.verticalDirection(target: view) == .stop {
                vc.transitionData.interactionController?.finish()
            } else if (gesture.verticalDirection(target: view) == .down) {
                vc.transitionData.interactionController?.finish()
            } else {
                vc.transitionData.interactionController?.cancel()
            }
            vc.transitionData.percent = 0
            vc.transitionData.interactionController = nil
        }
    }
}
