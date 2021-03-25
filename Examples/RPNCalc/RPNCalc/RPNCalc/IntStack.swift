//
//  IntStack.swift
//  RPNCalc
//
//  Created by cyroxin on 25.3.2021.
//

import Foundation

// LIFO integer stack buffer
class IntStack
{
    
    private var stack = [Int]()
    
    func push(_ v: Int)
    {
        stack += [v]
    }
    
    func pop() -> Int?
    {
        if(stack.count > 0)
        {
            return stack.removeLast()
        }
        
        return nil
    }
    
    func hasTwo() -> Bool
    {
        return stack.count >= 2
    }
}
