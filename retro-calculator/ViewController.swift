//
//  ViewController.swift
//  retro-calculator
//
//  Created by R. Maia on 5/17/16.
//  Copyright © 2016 RM. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var lblOutput: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber: String = ""
    var leftValueStr = ""
    var rightValueStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //path to the file
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        //creating a NSURL with the string path (AVAudioPlayer needs a NSURL)
        let soundPath: NSURL = NSURL(fileURLWithPath: path!)
        
        //Swift 2 force you to handle possible throws
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundPath)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    @IBAction func numberPressed(btn: UIButton!) {
        playSound()
        
        runningNumber += "\(btn.tag)"
        lblOutput.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            //Run math
            
            //A user selected an operator, but then selected another operator without first
            //entering a number
            if runningNumber != "" {
                rightValueStr = runningNumber
                runningNumber = ""
                
                if currentOperation ==  Operation.Multiply {
                    result = "\(Double(leftValueStr)! * Double(rightValueStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValueStr)! / Double(rightValueStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValueStr)! + Double(rightValueStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValueStr)! - Double(rightValueStr)!)"
                }
                
                leftValueStr = result
                lblOutput.text = result
            }
            
            
            currentOperation = op
            
        } else {
            //This is the first time an operator is been pressed
            leftValueStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    func playSound() {
        
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
}

