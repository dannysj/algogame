//
//  Theme.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/26/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    static func barColor() -> UIColor {
        return UIColor(hex: 0x853E8C)
    }
    
    static func barSecondaryColor() -> UIColor {
        return UIColor(hex: 0x631E7C)
    }
    
    
    static func scoreFont() ->UIFont {
        return UIFont(name: "Menlo-Regular", size: 25)!
    }
    
    static func codeFont() ->UIFont {
        return UIFont(name: "Menlo-Regular", size: 13)!
    }

    static func codeTitleFont() ->UIFont {
        return UIFont(name: "Menlo-Regular", size: 20)!
    }
    
    static func lineColor() -> UIColor {
        return UIColor.white
    }
    
    static func backgroundColor() -> UIColor {
        return UIColor(hex: 0x17264B)
    }
}
