//
//  ViewController.swift
//  #17
//
//  Created by T80 on 2016/06/03.
//  Copyright © 2016年 litech. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    //aaa
    
    var stageName: String!
    var stageNumber: Int = 1

    var playerView: UIImageView!
    var playerMotionManager: CMMotionManager!
    var speedX: Double = 0.0
    var speedY: Double = 0.0
    
    let screenSize = UIScreen.mainScreen().bounds.size
    var goalView: UIImageView!
    var startView: UIImageView!
    
    var wallRectArray = [CGRect]()
    var maze: [[Int]] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        
        let defaults = NSUserDefaults.standardUserDefaults()

        
        if let number = defaults.stringForKey("currentNumber"){
            stageNumber = Int(number)!
        }
        
        stageName = "Maze" + String(stageNumber)
        
       // stageName = "Maze" + String(stageNumber)
        print(stageName)
        
//        loadCSV()
//        
//        createMaze()
        
        //MotionManagerを作成
        playerMotionManager = CMMotionManager()
        playerMotionManager.accelerometerUpdateInterval = 0.02
        
        
        self.startAccelerometer()
        
    }
    
        
    override func viewWillAppear(animated: Bool) {
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let number = defaults.stringForKey("currentNumber"){
            stageNumber = Int(number)!
        }
        
        stageName = "Maze" + String(stageNumber)
        
        
        maze = []
        wallRectArray = []
        resetStage()
        loadCSV()
        createMaze()
        playerView.center = startView.center

        if !playerMotionManager.accelerometerActive {
            self.startAccelerometer()
        }
        
        speedX = 0.0
        speedY = 0.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCSV() {
        /*csvを読み込む*/
        if let csvPath = NSBundle.mainBundle().pathForResource(stageName, ofType: "csv") {
            var csvString=""
            do{
                csvString = try String(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            /*一行一行読み取ってカンマ(,)で区切って配列にいれる*/
            csvString.enumerateLines { (line, stop) -> () in
                let lineStrings: [String] = line.componentsSeparatedByString(",")  //カンマで区切る
                /*文字を整数に変換して配列にいれる*/
                var lineNums: [Int] = []
                for str in lineStrings {
                    lineNums.append(Int(str)!)
                }
                self.maze.append(lineNums)
            }
            print("maze = \(maze)") //中身を確認する
        }
        
    }
    
    func createMaze() {
        let cellWidth = screenSize.width / CGFloat(maze[0].count) // 6
        let cellHeight = screenSize.height / CGFloat(maze.count)//10
        
        let cellOffsetX = screenSize.width / CGFloat(maze[0].count * 2)
        let cellOffsetY = screenSize.height / CGFloat(maze.count * 2)
        
        for y in 0 ..< maze.count {
            for x in 0 ..< maze[y].count {
                switch maze[y][x] {
                case 1:
                    let wallView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    wallView.backgroundColor = UIColor(red: 187, green: 189, blue: 192, alpha: 1)
                    view.addSubview(wallView)
                    wallView.image = UIImage(named: "grey.png")
                    wallRectArray.append(wallView.frame)
                case 2:
                    startView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    startView.image = UIImage(named: "goal.png")
                    self.view.addSubview(startView)
                case 3:
                    goalView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    goalView.image = UIImage(named: "goal.png")
                    self.view.addSubview(goalView)
                default:
                    break
                }
            }
        }
        
        playerView = UIImageView(frame: CGRectMake(0 , 0, screenSize.width / 21.5, (screenSize.height) / 41.5))
        playerView.center = startView.center
        playerView.image = UIImage(named: "avatar.png")
        self.view.addSubview(playerView)

    }
    
    func resetStage() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }
    
    func createView(x x: Int, y: Int, width: CGFloat, height: CGFloat, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIImageView {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let view = UIImageView(frame: rect)
        
        let center = CGPoint(
            x: offsetX + width * CGFloat(x),
            y: offsetY + height * CGFloat(y)
        )
        
        view.center = center
        return view
    }
    
    func startAccelerometer() {
         //加速度を取得する
        let handler:CMAccelerometerHandler = {(accelerometerData:CMAccelerometerData?, error:NSError?) -> Void in
            
            self.speedX += accelerometerData!.acceleration.x
            self.speedY += accelerometerData!.acceleration.y
            
            var posX = self.playerView.center.x + (CGFloat(self.speedX) / 3)
            var posY = self.playerView.center.y - (CGFloat(self.speedY) / 3)
            
            if posX <= (self.playerView.frame.width / 2) {
                self.speedX = 0
                posX = self.playerView.frame.width / 2
            }
            if posY <= (self.playerView.frame.height / 2) {
                self.speedY = 0
                posY = self.playerView.frame.height / 2
            }
            if posX >= (self.screenSize.width - (self.playerView.frame.width / 2)) {
                self.speedX = 0
                posX = self.screenSize.width - (self.playerView.frame.width / 2)
            }
            if posY >= ((self.screenSize.height) - (self.playerView.frame.height / 2)) {
                self.speedY = 0
                posY = (self.screenSize.height) - (self.playerView.frame.height / 2)
            }
            
            for wallRect in self.wallRectArray {
                if (CGRectIntersectsRect(wallRect, self.playerView.frame)){
                    self.gameCheck("Game Over", message: "You Hit the Wall")
                    return
                }
            }
            
            if (CGRectIntersectsRect(self.goalView.frame, self.playerView.frame)){
                self.gameCheck("Clear", message: "You Win")
                return
            }
            
            self.playerView.center = CGPointMake(posX, posY)
    }
        playerMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: handler)


}
    
    func gameCheck(result:String,message:String){
        
        if playerMotionManager.accelerometerActive {
            playerMotionManager.stopAccelerometerUpdates()
        }
 
        if result == "Clear" {
            //クリア画面に遷移する
            let storyboard: UIStoryboard = self.storyboard!
            let clear: ClearViewController = storyboard.instantiateViewControllerWithIdentifier("Clear") as! ClearViewController
            self.presentViewController(clear, animated: true, completion: nil)
        }
        
        if result == "Game Over" {
            //ゲームオーバー画面に遷移する
            let storyboard: UIStoryboard = self.storyboard!
            let gameover: GameOverViewController = storyboard.instantiateViewControllerWithIdentifier("Game Over") as! GameOverViewController
            self.presentViewController(gameover, animated: true, completion: nil)
        }

    }

    func retry() {
        playerView.center = startView.center
        
        if !playerMotionManager.accelerometerActive {
            self.startAccelerometer()
        }
        
        speedX = 0.0
        speedY = 0.0
    }
}
