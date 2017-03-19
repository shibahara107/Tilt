//
//  LevelSelect.swift
//  #17
//
//  Created by Yoshi on 6/17/16.
//  Copyright © 2016 litech. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController {
    
    var stageNumber: Int = 0
    
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func selectLevel (button:UIButton){
        stageNumber = button.tag
        defaults.setValue(String(stageNumber), forKey: "currentNumber")
        performSegueWithIdentifier("toViewController",sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
