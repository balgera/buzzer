//
//  ViewController.swift
//  Buzzer Timer
//
//  Created by Brett Algera on 3/15/15.
//  Copyright (c) 2015 Brett Algera. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var startTimerBtnOutlet: UIBarButtonItem!
    @IBOutlet weak var pauseTimerBtnOutlet: UIBarButtonItem!
    @IBOutlet weak var audioSwitchOutlet: UISwitch!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    
    var buzzAudio: AVAudioPlayer?
    var timesUpAudio: AVAudioPlayer?
    var startAudio: AVAudioPlayer?
    var audioOn = true
    
    var seconds = 0
    var timeInput = 60
    
    var timer = NSTimer()
    
    @IBAction func audioSwitch(sender: AnyObject) {
        audioOn = audioSwitchOutlet.on
    }
    
    @IBAction func startTimerButton(sender: AnyObject) {
        if (startTimerBtnOutlet.title == "Start") {
            audioSwitchOutlet.enabled = false
            playCountdownAudio(true)
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
            
            startTimerBtnOutlet.title = "Stop"
            pauseTimerBtnOutlet.enabled = true
        } else {
            audioSwitchOutlet.enabled = true
            playCountdownAudio(false)
            timer.invalidate()
            seconds = timeInput;
            timerLabel.text = "\(seconds)"
            startTimerBtnOutlet.title = "Start"
            pauseTimerBtnOutlet.enabled = false
        }
    }
    
    @IBAction func pauseTimerButton(sender: AnyObject) {
        if (pauseTimerBtnOutlet.title == "Pause") {
            audioSwitchOutlet.enabled = true
            playCountdownAudio(false)
            timer.invalidate()
            pauseTimerBtnOutlet.title = "Resume"
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
            
            pauseTimerBtnOutlet.title = "Pause"
            playCountdownAudio(true)
            audioSwitchOutlet.enabled = false
        }
    }
    
    @IBAction func buzzerButton(sender: AnyObject) {
        if let buzzAudioPath = NSBundle.mainBundle().pathForResource("buzzer sfx", ofType: "wav") {
            buzzAudio = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: buzzAudioPath), fileTypeHint: "wav", error: nil)
            
            if let sound = buzzAudio {
                sound.prepareToPlay()
                sound.play()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playCountdownAudio(b:Bool) {
        if audioOn {
            if let startAudioPath = NSBundle.mainBundle().pathForResource("countdown audio", ofType: "wav") {
                startAudio = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: startAudioPath), fileTypeHint: "wav", error: nil)
                
                if let sound = startAudio {
                    if b {
                        sound.prepareToPlay()
                        sound.play()
                        sound.numberOfLoops = -1;
                    } else {
                        sound.stop()
                    }
                }
            }
        }
    }
    
    func setupTimer()  {
        seconds = timeInput
        timerLabel.text = "\(seconds)"
        remainingLabel.text = "seconds remaining"
        pauseTimerBtnOutlet.enabled = false
    }
    
    func subtractTime() {
        seconds--
        timerLabel.text = "\(seconds)"
        
        if (seconds == 1) {
            remainingLabel.text = "second remaining"
        } else {
            remainingLabel.text = "seconds remaining"
        }
        
        if(seconds <= 0)  {
            timer.invalidate()
            
            if (audioOn) {
                if let path = NSBundle.mainBundle().pathForResource("Buzz", ofType: "wav") {
                    timesUpAudio = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "wav", error: nil)
                    
                    if let sound = timesUpAudio {
                        sound.prepareToPlay()
                        sound.play()
                    }
                }
            }
            
            let alert = UIAlertController(title: "Time is up!",
                message: "Time is up!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                action in self.setupTimer()
            }))
            
            presentViewController(alert, animated: true, completion:nil)
            pauseTimerBtnOutlet.enabled = false
        }
    }
}