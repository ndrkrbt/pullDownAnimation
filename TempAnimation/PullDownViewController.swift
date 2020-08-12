//
//  PullDownViewController.swift
//  TempAnimation
//
//  Created by Andrey on 11/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class PullDownViewController: UIViewController, PullDownAnimatable, TransitioningDelegateble {
   
    var animatedMovingView: UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panUp = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(panUp)
    }
    
    var lastGestureLocation: CGPoint = .zero
    var startGestureLocation: CGPoint = .zero
    var percent: CGFloat = 0
    
    let customTransitionDelegate = TransitioningDelegate()
       
    required init?(coder aDecoder: NSCoder) {
        self.animatedMovingView = UIView()
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = customTransitionDelegate
    }
       
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        
        let gestureLocation = gesture.location(in: view)
        
        if gesture.state == .began {
            lastGestureLocation = gestureLocation
            startGestureLocation = gestureLocation
            interactionController = UIPercentDrivenInteractiveTransition()
            customTransitionDelegate.interactionController = interactionController
            dismiss(animated: true)
        } else if gesture.state == .changed {
            lastGestureLocation = gestureLocation
            let modifiedGestureLocation = abs(lastGestureLocation.y + gesture.view!.frame.origin.y)
            percent = ((modifiedGestureLocation - startGestureLocation.y) / UIScreen.main.bounds.height)/(1 - animatedMovingView.frame.maxY / UIScreen.main.bounds.height)
            interactionController?.update(percent)
        } else if gesture.state == .ended {
            if percent > 0.5 && gesture.verticalDirection(target: view) == .stop {
                interactionController?.finish()
            } else if (gesture.verticalDirection(target: view) == .down) {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            percent = 0
            interactionController = nil
        }
    }
}

protocol TransitioningDelegateble: class {
    var customTransitionDelegate: TransitioningDelegate { get }
}

extension TransitioningDelegateble where Self: UIViewController {
    
}
