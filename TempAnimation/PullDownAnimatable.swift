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
    var interactionController: UIPercentDrivenInteractiveTransition? {get set}
    var lastGestureLocation: CGPoint {get set}
    var startGestureLocation: CGPoint {get set}
    var percent: CGFloat {get set}
}

extension PullDownAnimatable where Self: UIViewController {
    func configurePan() {
        let panDown = UIPanGestureRecognizer(target: self, action: #selector(handlePullDownGesture(_:)))
        animatedMovingView.addGestureRecognizer(panDown)
    }
}

extension PullDownAnimatable where Self: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            return pan.verticalDirection(target: pan.view!) == .down
        }
        return false
    }
}

fileprivate extension UIViewController {
    
    @objc func handlePullDownGesture(_ gesture: UIPanGestureRecognizer) {
        print("swipe")
        
        guard var current = self as? PullDownAnimatable & TransitioningDelegateble else {
            return
        }
        
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let gestureLocation = gesture.location(in: view)
        
        if gesture.state == .began {
            current.lastGestureLocation = gestureLocation
            current.startGestureLocation = gestureLocation
            current.interactionController = UIPercentDrivenInteractiveTransition()
            current.customTransitionDelegate.interactionController = current.interactionController
            dismiss(animated: true)
        } else if gesture.state == .changed {
            current.lastGestureLocation = gestureLocation
            let changebleViewHeight = screenHeight - self.view.frame.origin.y
            let modifiedPercent = (self.view.frame.origin.y + current.lastGestureLocation.y - current.startGestureLocation.y)/screenHeight
            current.percent = modifiedPercent/(1 - changebleViewHeight/screenHeight)
            current.interactionController?.update(current.percent)
        } else if gesture.state == .ended {
            if current.percent > 0.5 && gesture.verticalDirection(target: view) == .stop {
                current.interactionController?.finish()
            } else if (gesture.verticalDirection(target: view) == .down) {
                current.interactionController?.finish()
            } else {
                current.interactionController?.cancel()
            }
            current.percent = 0
            current.interactionController = nil
        }
    }
}
