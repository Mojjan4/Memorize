//
//  Theme.swift
//  Memorizing
//
//  Created by Christopher Persson on 2020-07-17.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import SwiftUI

struct Theme {
    
    struct ThemeItem : Hashable, Codable, Identifiable {
        var id : Int  = newID()
        
        var themeName : String
        var themeEmojis : String
        
        var themeColor : UIColor.RGBA

        var themeUIColor: UIColor {
            get {
                UIColor(self.themeColor)
            }
            set{
                self.themeColor = newValue.rgba
            }
        }
        
        var lastScore : Int = 0
        var bestScore : Int  = 0
        
        var noOfPairsOfCards : Int = 1
        var bonusTimeLimit : Int = maxBonusTimeLimit / 2
        
        static var nextID = 5000
        
        static func newID () -> Int {
            Theme.ThemeItem.nextID = Theme.ThemeItem.nextID + 1
            return Theme.ThemeItem.nextID
        }
                
        static let maxBonusTimeLimit =  14
        static let maxNoOfPairsOfCards = 16
        static let noEmojis = "?"
        static let defaultThemeItem = ThemeItem(themeName : "Default", themeEmojis : noEmojis, themeColor : UIColor.clear.rgba)
    }

    var themeList : [ThemeItem]
    var themeCount : Int {
        themeList.count
    }

    mutating func addTheme() {

        self.themeList.append(Theme.ThemeItem(themeName :  "New Theme", themeEmojis : Theme.ThemeItem.noEmojis, themeColor : UIColor.black.rgba))
     }

    mutating func deleteThemes(offsets: IndexSet) {
         self.themeList.remove(atOffsets: offsets)
     }

    mutating func moveThemes(from: IndexSet, to: Int) {
         self.themeList.move(fromOffsets: from, toOffset: to)
     }
     
    mutating func storeScore(theme : Theme.ThemeItem, scoreCount : Int){
         if let themeNo = self.themeList.firstIndex(matching: theme) {
             self.themeList[themeNo].lastScore = scoreCount
             self.themeList[themeNo].bestScore = max(scoreCount, self.themeList[themeNo].bestScore)
         }
     }

    mutating func storeThemeItem(theme : Theme.ThemeItem){
         if let themeNo = self.themeList.firstIndex(matching: theme) {
             self.themeList[themeNo].themeName = theme.themeName
             self.themeList[themeNo].themeEmojis = theme.themeEmojis
             self.themeList[themeNo].themeColor = theme.themeColor
             self.themeList[themeNo].noOfPairsOfCards = theme.noOfPairsOfCards
             self.themeList[themeNo].bonusTimeLimit = theme.bonusTimeLimit
         }
     }
   
    
    let defaultGameDataFname = "MemorizeThemes.json"
    
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: fileUrl)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    
    func json<T: Encodable>( themeList : T) ->Data  {
        var json : Data
        do {
            let encoder = JSONEncoder()
            json = try encoder.encode(themeList)
        } catch {
            fatalError("Couldn't encode themeList as \(T.self):\n\(error)")
        }
        return json
    }
    
    init () {
        self.themeList = Theme.load(defaultGameDataFname)
    }
    
    init?(json: Data?) {
        if json != nil, let newThemeList = try? JSONDecoder().decode([ThemeItem].self, from: json!) {
            self.themeList = newThemeList
        } else {
            return nil
        }
    }
}

