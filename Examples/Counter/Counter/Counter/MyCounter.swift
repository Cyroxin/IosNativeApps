//
//  ViewController.swift
//  Counter
//
//  Created by cyroxin on 23.3.2021.
//  Copyright © 2021 cyroxin. All rights reserved.
//

class MyCounter {
    private(set) var lower : Int
    private(set) var upper : Int
    private(set) var value : Int
    
    init(_ from:Int = 0, to:Int = 9)
    {
        lower = from
        upper = to
        value = lower
    }
    
    func inc(_ by:Int = 1) {
        if(value + by <= upper)
        {
            value += by
        }
    }
    
    func dec(_ by:Int = 1) {
        if(value - by >= lower)
        {
            value -= by
        }
    }
    
}

