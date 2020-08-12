//
//  ViewControllerB.swift
//  TempAnimation
//
//  Created by Andrey on 07/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class SecondViewController: PullDownViewController {
    
    @IBOutlet weak var movingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.animatedMovingView = movingView
    }
}
