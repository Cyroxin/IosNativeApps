//
//  ViewController.swift
//  RPNCalc
//
//  Created by cyroxin on 25.3.2021.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    let stack = IntStack()

    @IBOutlet weak var mem4: UILabel! // Top
    @IBOutlet weak var mem3: UILabel!
    @IBOutlet weak var mem2: UILabel!
    @IBOutlet weak var mem1: UILabel!
    @IBOutlet weak var main: UILabel! // Bottom
    
    @IBAction func onClickNumber(_ sender: UIButton) {
        if let val = stack.pop()
        {
            stack.push(Int(String(val) + sender.currentTitle!)!)
        }
        else
        {
            stack.push(Int(sender.currentTitle!)!)
        }
        
        draw()
        
    }
    
    @IBAction func onClickSign() {
        if let val = stack.pop()
        {
            stack.push(-val)
            draw()
        }
    }
    
    @IBAction func onClickDelete() {
        if let val = stack.pop()
        {
            stack.push(
                Int(
                    String(String(val).dropLast(1))
                ) ?? 0
            )
            draw()
        }
    }
    
    @IBAction func onClickClear() {
        if(stack.pop() == nil)
        {
            stack.push(0)
        }
        draw()
    }

    @IBAction func onClickClearEverything() {
        while stack.hasTwo() {
            _ = stack.pop()
        }
        _ = stack.pop()
        stack.push(0)
        
        draw()
    }
    
    @IBAction func onClickEnter() {
        stack.push(0)
        draw()
    }
    
    @IBAction func onClickExp() {
        let val1 = Double(stack.pop() ?? 0)
        let val2 = Double(stack.pop() ?? 0)
        stack.push(Int(pow(val2,val1)))
        draw()
    }
    @IBAction func onClickDiv() {
        let val1 = stack.pop()
        
        if(val1 == nil)
        {
            return
        }
        else if(val1 == 0)
        {
            stack.push(0)
            return
        }
        
        let val2 = stack.pop()
        
        if(val2 == nil)
        {
            stack.push(val1!)
            return
        }
        
        stack.push(val2! / val1!)
        draw()
    }
    @IBAction func onClickMul() {
        let val1 = (stack.pop() ?? 0)
        let val2 = (stack.pop() ?? 0)
        stack.push(val2 * val1)
        draw()
    }
    @IBAction func onClickSub() {
        let val1 = (stack.pop() ?? 0)
        let val2 = (stack.pop() ?? 0)
        stack.push(val2 - val1)
        draw()
    }
    @IBAction func onClickAdd() {
        let val1 = (stack.pop() ?? 0)
        let val2 = (stack.pop() ?? 0)
        stack.push(val2 + val1)
        draw()
    }
    
    func draw()
    {
        // Clear old
        main.text = ""
        mem1.text = ""
        mem2.text = ""
        mem3.text = ""
        mem4.text = ""
        
        // Take new
        if let val = stack.pop()
        {
            print("mem1: ",val)
            main.text = String(val)
        }
        if let val = stack.pop()
        {
            print("mem2: ",val)
            mem1.text = String(val)
        }
        if let val = stack.pop()
        {
            print("mem3: ",val)
            mem2.text = String(val)
        }
        if let val = stack.pop()
        {
            print("mem4: ",val)
            mem3.text = String(val)
        }
        if let val = stack.pop()
        {
            print("mem5: ",val)
            mem4.text = String(val)
        }
        
        // Restore stack
        if let text = mem4.text
        {
            if let mem = Int(text)
            {
                stack.push(mem)
            }
        }
         if let text = mem3.text
               {
                   if let mem = Int(text)
                   {
                       stack.push(mem)
                   }
               }
        if let text = mem2.text
               {
                   if let mem = Int(text)
                   {
                       stack.push(mem)
                   }
               }
        if let text = mem1.text
               {
                   if let mem = Int(text)
                   {
                       stack.push(mem)
                   }
               }
        if let text = main.text
               {
                   if let mem = Int(text)
                   {
                       stack.push(mem)
                   }
               }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stack.push(0)
    }


}

