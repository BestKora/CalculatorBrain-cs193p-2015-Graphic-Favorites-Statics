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
    @IBOutlet weak var tochka: UIButton!{
        didSet {
            tochka.setTitle(decimalSeparator, forState: UIControlState.Normal)
        }
    }
 
    let decimalSeparator =  NSNumberFormatter().decimalSeparator ?? "."
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()

    private struct Constants {
        static let MaxHistoryTextLength: Int = 35
    }
   
    // property storing the evaluation results from the brain model
    // its Result type defined by enum in the brain model
    var displayResult: CalculatorBrain.Result = .Value(0.0) {
        // also updates the two IBOutlet text fields
        didSet {
            // using the description property of the
            // Result enum adhering to the printable protocol
            display.text = displayResult.description
            userIsInTheMiddleOfTypingANumber = false
            // history.text = brain.displayStack() + " ="
            // history.text = brain.description + " ="

            history.text = brain.description1 + "="
            //---history.text бегущей строкой-----
//            history.text = ticker(history.text!)
        }
    }
    
    // computed read-only property mirroring UILabel display.text
    var displayValue: Double? {
        get {
            if let displayText = display.text {
                return CalculatorBrain.numberFormatter().numberFromString(displayText)?.doubleValue
            }
            return nil
        }
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        //        println("digit = \(digit)");
        
        if userIsInTheMiddleOfTypingANumber {
            
             //----- Не пускаем избыточную точку ---------------
            if (digit == decimalSeparator) && (display.text?.rangeOfString(decimalSeparator) != nil) { return }
            //----- Уничтожаем лидирующие нули -----------------
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")){ return }
            if (digit != decimalSeparator) && ((display.text == "0") || (display.text == "-0"))
                                                              { display.text = digit ; return }
            //--------------------------------------------------
            display.text = display.text! + digit
        } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
                history.text = brain.description != "?" ? brain.description : " "
//                history.text = ticker(history.text!)
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            brain.performOperation(operation)
            displayResult = brain.evaluateAndReportErrors()
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let value = displayValue {
               brain.pushOperand(value)
            }
        displayResult = brain.evaluateAndReportErrors()
     }
    
    @IBAction func setVariable(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        
        let symbol = dropFirst(sender.currentTitle!)
        if let value = displayValue {
            brain.setVariable(symbol, value: value)
            displayResult = brain.evaluateAndReportErrors()

        }
    }
    
    @IBAction func pushVariable(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        brain.pushOperand(sender.currentTitle!)
        displayResult = brain.evaluateAndReportErrors()
    }
    
    @IBAction func clearAll(sender: AnyObject) {
          brain.clearAll()
          displayResult = brain.evaluateAndReportErrors()
    }
    
    @IBAction func backSpace(sender: AnyObject) {
        if userIsInTheMiddleOfTypingANumber {
            if countElements(display.text!) > 1 {
                display.text = dropLast(display.text!)
            } else {
                userIsInTheMiddleOfTypingANumber = false
                displayResult = brain.evaluateAndReportErrors()
            }
        } else {
            brain.popStack()
            displayResult = brain.evaluateAndReportErrors()
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
    

    func ticker (text: String ) -> String {
        var textTicker = text
        let countText = countElements(textTicker)
        if countText > Constants.MaxHistoryTextLength {
            textTicker = textTicker[advance(textTicker.startIndex,
                           countText - Constants.MaxHistoryTextLength )..<textTicker.endIndex]
            let myStringArr = textTicker.componentsSeparatedByString(" ")
            var myStringArr1 = myStringArr[1..<myStringArr.count]
            if !myStringArr1.isEmpty { textTicker =  " ".join(myStringArr1)}
            textTicker =  "... " + textTicker
        }
        return textTicker
    }
}

