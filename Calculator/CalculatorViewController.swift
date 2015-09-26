//
//  ViewController.swift
//  Calculator
//
//  Created by Jake Alsemgeest on 2015-09-24.
//  Copyright © 2015 Jalsemgeest. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController
{

    // MARK: - Outlets
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    
    // MARK: - Properties
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()
    
    
    // MARK: - Button Actions
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            // If the user enters a point and there isn't a point already, then return.
            if digit == "." && display.text!.rangeOfString(".") != nil { return }
            if digit == "0" && (display.text! == "0" || display.text == "-0") { return }
            if digit != "." && (display.text! == "0" || display.text == "-0") {
                if display.text == "0" {
                    display.text = digit
                } else {
                    display.text = "-" + digit
                }
            } else {
                display.text = display.text! + digit
            }
        } else {
            if digit == "." {
                display.text = "0."
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
            history.text = brain.showStack()
        }
    }

    @IBAction func operate(sender: UIButton)
    {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                
                displayValue = result
                history.text = history.text! + " ="
            } else {
                displayValue = nil
                // Should say it is nil
            }
        }
    }
    
    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            print(result)
            displayValue = result
        } else {
            displayValue = nil
            // Should say it is nil
        }
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            let displayText = display.text!
            if displayText.characters.count > 1 {
                display.text = String(displayText.characters.dropLast())
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func clear() {
        brain = CalculatorBrain()
        displayValue = nil
        history.text = " "
    }
    
    
    // MARK: - Computed Properties
    
    var displayValue: Double? {
        get {
            if let displayText = display.text {
                if let displayNumber = NSNumberFormatter().numberFromString(displayText) {
                    return displayNumber.doubleValue
                }
            }
            return nil
        }
        set {
            if newValue != nil {
                display.text = "\(newValue!)"
            } else {
                display.text = "0"
            }
            userIsInTheMiddleOfTypingANumber = false
            let stack = brain.showStack()
            if !stack!.isEmpty {
                history.text = stack!
            }
        }
    }
    
}

