//
//  Clear.swift
//  #17
//
//  Created by Yoshi on 11/18/16.
//  Copyright © 2016 litech. All rights reserved.
//

import UIKit

class ClearViewController: UIViewController {
    
    var RetryButton2: UIButton!
    var HomeButton2: UIButton!
    var nextButton: UIButton!
    var stageNumber: Int = 0
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let number = defaults.stringForKey("currentNumber"){
            stageNumber = Int(number)!
        }
        
        stageNumber = stageNumber+1


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retry() {
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func home() {
        let storyboard: UIStoryboard = self.storyboard!
        let home: HomeViewController = storyboard.instantiateViewControllerWithIdentifier("home") as! HomeViewController
        self.presentViewController(home, animated: true, completion: nil)
    }
    
    @IBAction func next() {
        defaults.setValue(String(stageNumber), forKey: "currentNumber")
        dismissViewControllerAnimated(true, completion: nil)

        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
