//
//  ViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 2/5/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    @IBOutlet weak var tochka: UIButton!
    
    let decimalSeparator = NSNumberFormatter().decimalSeparator ?? "."
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        //        println("digit = \(digit)");
        
        if userIsInTheMiddleOfTypingANumber {
            //----- Уничтожаем лидирующие нули ---------------
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")){ return }
            if (digit != decimalSeparator) && ((display.text == "0")  || (display.text == "-0")) { display.text = digit ; return }
            //--------------------------------------------------
            display.text = display.text! + digit
        } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
                history.text = history.text!.rangeOfString("=") != nil ? dropLast( history.text!) :  history.text
        }
    }
    
    @IBAction func decimalPoint(sender: UIButton) {
        let noPointOnDisplay = display.text?.rangeOfString(decimalSeparator) == nil
        if (noPointOnDisplay) || !noPointOnDisplay && !userIsInTheMiddleOfTypingANumber {
            appendDigit(sender)
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                 history.text =  history.text! + " ="
            } else {
                // error?
                displayValue = nil  // задание 2
                history.text =  history.text! + " ERROR"
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let value = displayValue {
               displayValue = brain.pushOperand(value)
            } else {
               displayValue = nil
        }
     }
    
    @IBAction func clearAll(sender: AnyObject) {
          brain = CalculatorBrain()
          displayValue = nil
    }
 
    @IBAction func backSpace(sender: AnyObject) {
        if userIsInTheMiddleOfTypingANumber {
            if countElements(display.text!) > 1 {
                display.text = dropLast(display.text!)
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func plusMinus(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if (display.text!.rangeOfString("-") != nil) {
                display.text = dropFirst(display.text!)
            } else {
                display.text = "-" + display.text!
            }
        } else {
            operate(sender)
        }
    }
    
    var displayValue: Double? {
        get {
            if let displayText = display.text {
               return NSNumberFormatter().numberFromString(displayText)?.doubleValue
            }
            return nil
        }
        set {
            if (newValue != nil) {
                display.text = "\(newValue!)"
            } else {
                display.text = " "
            }
            userIsInTheMiddleOfTypingANumber = false
            history.text = brain.displayStack() ?? " "
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tochka.setTitle(decimalSeparator, forState: UIControlState.Normal)
        display.text = " "
        displayValue = nil
    }
}

