//
//  StartViewController.swift
//  TempAnimation
//
//  Created by Andrey on 12/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        let vc = ViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
