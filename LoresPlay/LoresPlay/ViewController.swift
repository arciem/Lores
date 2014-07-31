//
//  ViewController.swift
//  LoresPlay
//
//  Created by Robert McNally on 7/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit
import Lores

class ViewController: UIViewController {
    @IBOutlet weak var programView: ProgramView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        programView.program = program
        programView.program.didDisplay = {
            self.programView.flush()
        }
    }
    
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        programView.program.display()
    }
}

