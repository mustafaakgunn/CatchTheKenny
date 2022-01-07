//
//  ViewController.swift
//  CatchTheKenny
//
//  Created by MUSTAFA AKGÜN on 7.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    var score = 0
    var timer = Timer()
    var counter = 1
    var teleportTimer = Timer()
    var highScore = 0
    
    //Locations that I've decided to place Kenny. I will use them randomly with teleportKenny function...
    var xCoordinates = [0.05, 0.4, 0.725]
    var yCoordinates = [0.25, 0.45, 0.65]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //High-score check from local memory...
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighScore == nil {
            highScore = 0
            highscoreLabel.text = "Highscore : \(highScore)"
        }
        
        if let newScore = storedHighScore as? Int{
            highScore = newScore
            highscoreLabel.text = "Highscore: \(highScore)"
        }
        
        //Now It's setted for 10 seconds-game.
        counter = 10
        timeLabel.text = "\(counter)"
        
        //timer is for countdown and teleportTimer handles transporting Kenny in screen with declared amount of time.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        teleportTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(teleportKenny), userInfo: nil, repeats: true)
        
    }
    
    //For repeat location synchronously with teleport timer, I added UIImageView here. It comes with teleportKenny function, not directly placed in viewDidLoad.
    
    @objc func teleportKenny(){
        
        //Random Int value generators for my location arrays.
        let xCoordinate = Int(arc4random_uniform(UInt32(xCoordinates.count)))
        let yCoordinate = Int(arc4random_uniform(UInt32(yCoordinates.count)))
        
        //For complete this game with an only imageView I declared my imageView as a code. So, I can manipulate it when program running.
        var imageView = UIImageView()
        let width = view.frame.size.width
        let height = view.frame.size.height
        imageView.frame = CGRect(x: (width*xCoordinates[xCoordinate]), y:(height*yCoordinates[yCoordinate]), width: 100, height: 100)
        imageView.image = UIImage(named:"kenny.jpeg")
        self.view.addSubview(imageView)
        
        //Score counters are here.
        imageView.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        
        imageView.addGestureRecognizer(recognizer)
        
        // Added a async delayer for make Kenny go from the screen after time is done for every step...
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            imageView.isHidden = true}
 
    }
    
    @objc func countdown(){
        
        counter -= 1
        timeLabel.text = "\(counter)"
        
        if counter == 0 {
            timer.invalidate()
            teleportTimer.invalidate()
            
            
            //If high-score is succeed it will saved to local.
        if self.score > self.highScore {
            self.highScore = self.score
            highscoreLabel.text = "Highscore: \(self.highScore)"
            UserDefaults.standard.set(self.highScore, forKey: "highscore")
            }
            
            
            
            
            //"Time is over" actions are declared here...
            
            let alert = UIAlertController(title: "Time is over", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            
            //Replay button for start again.
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) {
                (UIAlertAction) in
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.counter = 10
                self.timeLabel.text = String(self.counter)
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
                self.teleportTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.teleportKenny), userInfo: nil, repeats: true)
            }
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func increaseScore(){
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    }
    


