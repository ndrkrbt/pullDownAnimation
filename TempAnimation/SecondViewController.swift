//
//  ViewControllerB.swift
//  TempAnimation
//
//  Created by Andrey on 07/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, TransitioningDelegateble {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = customTransitionDelegate
    }
    
    var transitionData = PullDownTransitionData()
    var customTransitionDelegate = TransitioningDelegate()
    
    @IBOutlet weak var movingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePullDownPanGestureRecognizer()
    }
}

extension SecondViewController: PullDownAnimatable {
    var animatedMovingView: UIView {
        return movingView
    }
}
