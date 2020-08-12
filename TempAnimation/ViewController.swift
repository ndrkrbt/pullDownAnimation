//
//  ViewController.swift
//  TempAnimation
//
//  Created by Andrey on 07/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class ViewController: PullUpViewController {
    
    class func instantiate() -> ViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        viewController.secondVC = secondVC
        return viewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.animatedMovingView = mainView
        super.secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
    }
    
    @IBOutlet weak var mainView: UIView!
}
