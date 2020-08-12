//
//  PullDownAnimationController.swift
//  TempAnimation
//
//  Created by Andrey on 11/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit


protocol PullUpAnimatable {
    var animatedMovingView: UIView { get }
    var secondVC: UIViewController & TransitioningDelegateble { get }
    var interactionController: UIPercentDrivenInteractiveTransition? {get set}
    var lastGestureLocation: CGPoint {get set}
    var startGestureLocation: CGPoint {get set}
    var percent: CGFloat {get set}
}

extension PullUpAnimatable {
    
}



extension PullUpAnimatable where Self: UIViewController {
    func configurePan() {
        let panDown = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
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
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        print("swipe")
        
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


@objc protocol PullDownAnimatable {
    var animatedMovingView: UIView { get set }
    
   // @objc optional func handleGesture(_ gesture: UIPanGestureRecognizer)
    
    var secondVC: UIViewController { get }
}

extension PullDownAnimatable {
   
    
}


