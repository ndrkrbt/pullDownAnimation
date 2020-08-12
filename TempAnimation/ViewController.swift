//
//  ViewController.swift
//  TempAnimation
//
//  Created by Andrey on 07/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    class func instantiate() -> ViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let second = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        viewController.second = second
        return viewController
    }
    
    var second: (UIViewController & TransitioningDelegateble)!
    var interactionController: UIPercentDrivenInteractiveTransition?
    var lastGestureLocation: CGPoint = .zero
    var startGestureLocation: CGPoint = .zero
    var percent: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePan()
        second = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
    }
    
    @IBOutlet weak var mainView: UIView!
}

extension ViewController : PullUpAnimatable {

    var secondVC: UIViewController & TransitioningDelegateble {
        return second
    }
    
    
    var animatedMovingView: UIView {
        return mainView
    }
}


