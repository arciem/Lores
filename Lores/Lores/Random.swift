//
//  Random.swift
//  Lores
//
//  Created by Bevan Essman on 8/3/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Arciem

public class Random {
    public class func randomFlat() -> Double {
        return random.randomFlat()
    }
    
    public class func randomRange(#min:Double, max:Double) -> Double {
        return random.randomRange(min:min, max:max)
    }
    
    public class func randomInt(#min:Int, max:Int) -> Int {
        return random.randomInt(min:min, max:max)
    }
    
    public class func randomBoolean() -> Bool {
        return random.randomBoolean()
    }
}
