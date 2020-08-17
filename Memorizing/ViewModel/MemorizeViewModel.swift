//
//  MemorizingViewModel.swift
//  Memorizing
//
//  Created by Christopher Persson on 2020-07-17.
//  Copyright © 2020 Christopher Persson. All rights reserved.


import Foundation
import Combine

typealias ModelType = MemorizeModel<String>

final class MemorizeViewModel : ObservableObject{
    @Published  private var gameModel : ModelType?
    @Published  private var themes : Theme
    
    
    private func createMemoryGame (theme : Theme.ThemeItem) -> ModelType {
        var emojis = theme.themeEmojis
        return ModelType(numberOfPairsOfCards: theme.noOfPairsOfCards, bonusTimeLimit : theme.bonusTimeLimit ) {_ in
            String(emojis.removeFirst())
        }
    }
    
    var cards : [ModelType.Card] {
        gameModel?.cards ?? [ModelType.Card]()
    }
    
    var themeList : [Theme.ThemeItem] {
        themes.themeList
    }
    
    var gameScore : Int {
        gameModel?.scoreCount ?? 0
    }
    
    var flipCount : Int {
        gameModel?.flipCount ?? 0
    }
    
    func chooseCard(card chosenCard : ModelType.Card) {
        gameModel!.choose(card: chosenCard)
    }
    
    // Add new Theme
    func addTheme() {
        self.themes.addTheme()
    }
    
    func deleteThemes(offsets: IndexSet) {
        self.themes.deleteThemes(offsets: offsets)
    }
    
    func moveThemes(from: IndexSet, to: Int) {
        self.themes.moveThemes(from: from, to: to)
    }
    
    func storeScore(theme : Theme.ThemeItem){
        self.themes.storeScore(theme : theme, scoreCount: gameModel?.scoreCount ?? 0)
    }
    
    func storeThemeItem(theme : Theme.ThemeItem) {
        self.themes.storeThemeItem(theme : theme)
    }
    
    // start new game
    func newGame (theme: Theme.ThemeItem) {
        gameModel = createMemoryGame(theme : theme)
    }
    
    private var autosaveCancellable : AnyCancellable?
    let MemorizeLastSessionData = "Memorize.State"
    
    init() {
        themes = Theme(json: UserDefaults.standard.data(forKey: MemorizeLastSessionData)) ?? Theme()
        autosaveCancellable = $themes.sink{ theme in
            let json : Data = theme.json(themeList : theme.themeList)
            UserDefaults.standard.set(json, forKey : self.MemorizeLastSessionData)
        }
    }
}
