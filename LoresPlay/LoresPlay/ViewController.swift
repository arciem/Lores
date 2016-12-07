//
//  ViewController.swift
//  LoresPlay
//
//  Created by Robert McNally on 10/1/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit
import Lores

class ViewController: UIViewController {
    @IBOutlet weak var programView: ProgramView!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        programView.program = program
        programView.program.didDisplay = {
            self.programView.flush()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
        programView.program.display()
    }

}

