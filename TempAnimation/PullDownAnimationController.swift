//
//  PullDownAnimationController.swift
//  TempAnimation
//
//  Created by Andrey on 11/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import UIKit

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
                let movingView = (toVC as? PullUpAnimatable)?.animatedMovingView else {
                    return
            }
                    
            toView.frame = frame
            inView.insertSubview(toView, belowSubview: fromView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
                
                let coef = movingView.frame.origin.y / UIScreen.main.bounds.height
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

