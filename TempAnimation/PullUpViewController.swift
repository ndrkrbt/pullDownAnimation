//
//  PullUpViewController.swift
//  TempAnimation
//
//  Created by Andrey on 11/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class PullUpViewController: UIViewController, PullDownAnimatable {
  
    var animatedMovingView: UIView {
        didSet {
            let panDown = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
            animatedMovingView.addGestureRecognizer(panDown)
        }
    }
    var secondVC: (UIViewController & TransitioningDelegateble)?

    required init?(coder aDecoder: NSCoder) {
        self.animatedMovingView = UIView()
        super.init(coder: aDecoder)
    }

    private var interactionController: UIPercentDrivenInteractiveTransition?
    
    var lastGestureLocation: CGPoint = .zero
    var startGestureLocation: CGPoint = .zero
    var percent: CGFloat = 0
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {

        guard let secondVC = secondVC else {
            return
        }
        
        let gestureLocation = gesture.location(in: view)
        
        if gesture.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            lastGestureLocation = gestureLocation
            startGestureLocation = gestureLocation
            secondVC.customTransitionDelegate.interactionController = interactionController
            present(secondVC, animated: true)
        } else if gesture.state == .changed {
            lastGestureLocation = gestureLocation
            let deltaGesture = (startGestureLocation.y - lastGestureLocation.y) / UIScreen.main.bounds.height
            let coefficient = self.animatedMovingView.frame.origin.y / UIScreen.main.bounds.height
            percent = deltaGesture/coefficient
            interactionController?.update(percent)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if gesture.verticalDirection(target: view) == .up {
                interactionController?.finish()
            } else if gesture.verticalDirection(target: view) == .stop && percent > 0.5 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            percent = 0
            interactionController = nil
        }
    }
}


extension PullUpViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            return pan.verticalDirection(target: pan.view!) == .up
        }
        return false
    }
}
