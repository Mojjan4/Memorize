//
//  MemorizeModel.swift
//  Memorizing
//
//  Created by Christopher Persson on 2020-07-17.
//  Copyright © 2020 Christopher Persson. All rights reserved.
//

import Foundation

struct MemorizeModel <CardContent> where CardContent : Equatable{
    // cards are visible, but cannot be changed from a view
    private(set) var cards : [Card]
    // Scoring
    private(set) var flipCount  = 0, scoreCount = 0
    
    private var indexOfOneAndOnlyFaceUpCard : Int? {
        get {
            cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        set (newValue){
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func choose(card chosenCard : Card) {
        
        if let index = cards.firstIndex(matching : chosenCard){
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                if cards[matchIndex].content == cards[index].content {
                        // They match, mark both as matched
                        scoreCount += 2
                        cards[matchIndex].isMatched = true
                        cards[index].isMatched = true
                        if cards[index].bonusTimeRemaining > 0 {
                            scoreCount += 1
                        }
                        if cards[matchIndex].bonusTimeRemaining > 0 {
                            scoreCount += 1
                        }
                    } else{
                        for i in [index, matchIndex] {
                            if cards[i].alreadySeen {
                                scoreCount -= 1
                            
                                if cards[index].bonusTimeRemaining == 0 {
                                    scoreCount -= 1
                                }
                            }
                            else {
                                cards[i].alreadySeen = true
                            }
                        }
                    }
                    cards[index].isFaceUp = true
                
                } else {
                    indexOfOneAndOnlyFaceUpCard = index
                }
                flipCount += 1
                
            }
    }
    init(numberOfPairsOfCards : Int, bonusTimeLimit : Int, cardContentFactory : (Int)->CardContent) {
        
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards += [Card( id :  2 * pairIndex, content: content, bonusTimeLimit : bonusTimeLimit  ),
                      Card( id : 2 * pairIndex + 1, content: content, bonusTimeLimit : bonusTimeLimit )]
        }
        cards.shuffle()
    }
    
    struct Card : Identifiable {
        
            var id : Int
            var content : CardContent
        
            var isFaceUp : Bool {
                didSet {
                    if isFaceUp {
                        startUsingBonusTime()
                    } else {
                        stopUsingBonusTime()
                    }
                }
            }
            var isMatched : Bool {
                didSet{
                    stopUsingBonusTime()
                }
            }
            
            var alreadySeen : Bool
            
            var bonusTimeLimit : TimeInterval
            
            var lastFaceUpDate : Date?
            
            var pastFaceUpTime : TimeInterval = 0
        
        init( id : Int = 0, isFaceUp : Bool = false, isMatched : Bool = false, alreadySeen : Bool = false, content : CardContent, bonusTimeLimit : Int){
            self.id = id
            self.isFaceUp = isFaceUp
            self.isMatched = isMatched
            self.alreadySeen = alreadySeen
            self.content = content
            self.bonusTimeLimit = TimeInterval(bonusTimeLimit)
        }
    
    
        // MARK: - Bonus Time
        
        // how long this card has ever been face up
        private var faceUpTime : TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var bonusTimeRemaining : TimeInterval{
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining : Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0 ? bonusTimeRemaining /  bonusTimeLimit : 0)
        }
        
        var hasEarnedBonus : Bool {
            isMatched && (bonusTimeRemaining > 0)
        }
        
        var isConsumingBonusTime : Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
