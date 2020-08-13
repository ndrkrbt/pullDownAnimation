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
    
    var second: UIViewControllerWithTransition = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
    var transitionData = PullDownTransitionData(isPercentDriven: false)
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePullUpPanGestureRecognizer()
    }
}

extension ViewController : PullUpAnimatable {
    var showingVC: UIViewControllerWithTransition {
        return second
    }
    
    var animatedMovingView: UIView {
        return mainView
    }
}


