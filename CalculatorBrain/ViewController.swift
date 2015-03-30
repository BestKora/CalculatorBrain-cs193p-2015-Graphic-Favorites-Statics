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
        static let MaxHistoryTextLength: Int = 38
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
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                 displayValue = result
            } else {
                // error?
                displayValue = nil
            }
             history.text = history.text!         }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let value = displayValue {
               displayValue = brain.pushOperand(value)
            } else {
               displayValue = nil
        }
     }
    
    @IBAction func setVariable(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        
        let symbol = dropFirst(sender.currentTitle!)
        if let value = displayValue {
            brain.setVariable(symbol, value: value)
            displayValue = brain.evaluate()
        }
    }
    
    @IBAction func pushVariable(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        displayValue = brain.pushOperand(sender.currentTitle!)
    }
    
    @IBAction func clearAll(sender: AnyObject) {
          brain.clearAll()
          displayValue = nil
    }
    
    @IBAction func backSpace(sender: AnyObject) {
        if userIsInTheMiddleOfTypingANumber {
            if countElements(display.text!) > 1 {
                display.text = dropLast(display.text!)
            } else {
                displayValue = nil
            }
        } else {
            displayValue = brain.popStack()
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
                return numberFormatter().numberFromString(displayText)?.doubleValue
            }
            return nil
        }
        set {
            if (newValue != nil) {
                display.text = numberFormatter().stringFromNumber(newValue!)
            } else {
                display.text = " "
            }
            userIsInTheMiddleOfTypingANumber = false
            
         // history.text = brain.displayStack() + " ="
         // history.text = brain.description + " ="
            
            history.text = brain.description1 + " ="
       
//---history.text бегущей строкой-----
            
            history.text = ticker(history.text!)
        }
    }

    func numberFormatter () -> NSNumberFormatter{
        let numberFormatterLoc = NSNumberFormatter()
        numberFormatterLoc.numberStyle = .DecimalStyle
        numberFormatterLoc.maximumFractionDigits = 10
        numberFormatterLoc.notANumberSymbol = "Error"
        numberFormatterLoc.groupingSeparator = " "
        return numberFormatterLoc
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

