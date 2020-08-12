//
//  PullDownAnimationController.swift
//  TempAnimation
//
//  Created by Andrey on 11/08/2020.
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

extension PullDownAnimatable {
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
        let gestureLocation = gesture.location(in: view)
        
        if gesture.state == .began {
            current.lastGestureLocation = gestureLocation
            current.startGestureLocation = gestureLocation
            current.interactionController = UIPercentDrivenInteractiveTransition()
            current.customTransitionDelegate.interactionController = current.interactionController
            dismiss(animated: true)
        } else if gesture.state == .changed {
            current.lastGestureLocation = gestureLocation
            
            print("current.lastGestureLocation.y \(current.lastGestureLocation.y)")
            print("gesture \(gesture.view!.frame.origin.y)")
            
            let modifiedGestureLocation = abs(current.lastGestureLocation.y + gesture.view!.frame.origin.y)
            
            print("modifiedGestureLocation \(modifiedGestureLocation)")
            current.percent = ((modifiedGestureLocation - current.startGestureLocation.y) / UIScreen.main.bounds.height)/(1 - current.animatedMovingView.frame.maxY / UIScreen.main.bounds.height)
            print(current.percent)
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



class PullDownAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionType {
        case presenting
        case dismissing
    }
    
    let transitionType: TransitionType
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from) else {
                return
        }
       
        let inView = transitionContext.containerView
        var frame = inView.bounds
        
        switch transitionType {
        case .presenting:
            
            guard let navVC = transitionContext.viewController(forKey: .from) as? UINavigationController,
                let toVC = navVC.viewControllers.last as? ViewController,
            //{let toVC = transitionContext.viewController(forKey: .from) as? ViewController,
                let movingView = (toVC as? PullUpAnimatable)?.animatedMovingView else {
                    return
            }
            
            let coef =  movingView.frame.origin.y / UIScreen.main.bounds.height
            
            frame.origin.y = coef*frame.size.height
            toView.frame = frame
            inView.addSubview(toView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
                toView.frame = inView.bounds
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        case .dismissing:
             //let toVC = transitionContext.viewController(forKey: .to) as? ViewController,
             guard let navVC = transitionContext.viewController(forKey: .to) as? UINavigationController,
                let toVC = navVC.viewControllers.last as? ViewController,
                let movingView = (toVC.presentedViewController as? PullDownAnimatable)?.animatedMovingView else {
                    return
            }
                    
            toView.frame = frame
            inView.insertSubview(toView, belowSubview: fromView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
                
                let coef = 1 - movingView.frame.size.height / UIScreen.main.bounds.height
                frame.origin.y = frame.size.height*coef
                fromView.frame = frame
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
}

