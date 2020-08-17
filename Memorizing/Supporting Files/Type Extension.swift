//
//  Type Extension.swift
//  Memorizing
//
//  Created by Christopher Persson on 2020-07-17.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import SwiftUI

// Find item in array of items in an index of identifiable
extension Array where Element : Identifiable {
    func firstIndex(matching element: Element) -> Int? {
        return self.firstIndex{$0.id == element.id}
    }
}

extension Array {
    var oneAndOnly : Element? {
        get {
            return count == 1 ? first : nil
        }
    }
}

// Int extension used for random number generatiom from 0..<self
extension Int {
    var arc4random : Int {
        get {
            return (self > 0 ?
                        Int(arc4random_uniform(UInt32(self))) :
                        (self < 0 ?
                            -Int(arc4random_uniform(UInt32(abs(self)))) :
                            0))
        }
    }
}

extension Color {
    init(_ rgba: UIColor.RGBA) {
        self.init(UIColor(rgba))
    }
}

extension UIColor {
    public struct RGBA: Hashable, Codable {
         var red: CGFloat
         var green: CGFloat
         var blue: CGFloat
         var alpha: CGFloat
    }
    
    convenience init(_ rgb: RGBA) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }
    
    public var rgba: RGBA {
         var red: CGFloat = 0
         var green: CGFloat = 0
         var blue: CGFloat = 0
         var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }
}
 
