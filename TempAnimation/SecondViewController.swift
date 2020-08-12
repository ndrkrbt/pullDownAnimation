//
//  ViewControllerB.swift
//  TempAnimation
//
//  Created by Andrey on 07/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, TransitioningDelegateble {
    
    @IBOutlet weak var movingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         configurePan()
    }
    
    var lastGestureLocation: CGPoint = .zero
    var startGestureLocation: CGPoint = .zero
    var percent: CGFloat = 0
    var customTransitionDelegate = TransitioningDelegate()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = customTransitionDelegate
    }
    
    var interactionController: UIPercentDrivenInteractiveTransition?
}

extension SecondViewController: PullDownAnimatable {
    var animatedMovingView: UIView {
        return movingView
    }
}
