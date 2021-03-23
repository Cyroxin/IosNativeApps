//
//  ViewController.swift
//  Counter
//
//  Created by cyroxin on 23.3.2021.
//  Copyright © 2021 cyroxin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var counter = MyCounter(1, to: 10)
    
    // Stepper button
    @IBOutlet weak var stepper: UIStepper!
    
    // Step amount input
    @IBOutlet weak var amountInput: UITextField!
    
    // Counter label
    @IBOutlet weak var valueLabel: UILabel!
    
    
    // Input Amount Changed
    @IBAction func onStepAmountChangingEnd(_ sender: UITextField, forEvent event: UIEvent) {
        
        // Try to parse input into Int
        if let step = Int(sender.text!) {
            
            // Set new step size
            stepper.stepValue = Double(step)
            
            NSLog("Step amount: %@", String(step))
        }
        else if(sender.text != "")
        {
            // Parse fail, reset
            amountInput.text = String(stepper.stepValue)
        }
    }
    
    // Stepper Button Pressed
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
        // Increment / Decrement
        let increment = counter.value < Int(sender.value)
        
        // Amount to increment/decrement
        let amount = Int(stepper.stepValue)
        
        
        
        if(increment) // Increment
        {
            // Bounds check
            if (counter.value + amount > counter.upper) {
                
                // Amount too large
                // Increment max possible
                counter.inc(counter.upper - counter.value)
                
            }
            else
            {
                // Can increment directly
                counter.inc(amount)
            }
        }
        else // Decrement
        {
            // Bounds check
            if (counter.value - amount < counter.lower)
            {
                
                // Amount too large
                // Decrement max possible
                counter.dec(counter.value - counter.lower)
                
            }
            else
            {
                // Can decrement directly
                counter.dec(amount)
            }
        }
        
        NSLog("Increment? %@", String(increment))
        NSLog("stepValue %@", String(amount))
        
        NSLog("v-value %@", String(sender.value))
        NSLog("d-value %@", String(counter.value))
        
        // Update UI: counter label
        valueLabel.text = String(counter.value)
        
    }
}

