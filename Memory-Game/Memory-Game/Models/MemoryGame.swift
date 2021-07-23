//
//  MemoryGame.swift
//  Memory-Game
//
//  Created by user196689 on 7/17/21.
//

import Foundation
protocol MemoryGameProtocol {
    //protocol definition goes here
    func memoryGameDidStart(_ game: MemoryGame)
    func memoryGameDidEnd(_ game: MemoryGame)
    func memoryGame(_ game: MemoryGame, showCards cards: [Card])
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card])
}
class MemoryGame{
    var delegate: MemoryGameProtocol?
    var cards: [Card] = [Card]()
    var cardsShown: [Card] = [Card]()
    var isPlaying: Bool = false
    var count: Int = 0
    
    func setCount(count: Int){
        self.count = count
    }
    func getCount() -> Int{
        return self.count
    }
    
    func shuffleCards(cards: [Card]) -> [Card]{
        var randonCards = cards
        randonCards.shuffle()
        return randonCards
    }
    func newGame(cardsArray: [Card]) -> [Card]{
        cards = shuffleCards(cards: cardsArray)
        isPlaying = true
        
        delegate?.memoryGameDidStart(self)
        self.count = 0
        return cards
    }
    func restartGame(){
        isPlaying = false
        cards.removeAll()
        self.count = 0
        cardsShown.removeAll()
    }
    func cardAtIndex(_ index: Int) -> Card?{
        if(cards.count > index){
            return cards[index]
        }
        else{
            return nil
        }
    }
    func indexForCard(_ card: Card) -> Int?{
        for index in 0...cards.count-1{
            if(card === cards[index]){
                return index
            }
        }
        return nil
    }
    func unmatchedCardShown() -> Bool{
        return cardsShown.count % 2 != 0
    }
    func unmatchedCard() -> Card?{
        let unmatchedCard = cardsShown.last
        return unmatchedCard
    }
    func didSelectCard(_ card: Card?){
        guard let card = card else { return }
        delegate?.memoryGame(self, showCards: [card])

        
        if (unmatchedCardShown()){
            let unmatched = unmatchedCard()!
            if (card.equals(unmatched)){
                cardsShown.append(card)
            } else{
                let secondCard = cardsShown.removeLast()
                let delayTime = DispatchTime.now() + 0.5
                 DispatchQueue.main.asyncAfter(deadline: delayTime) {
                     self.delegate?.memoryGame(self, hideCards:[card, secondCard])
                 }
            }
            self.count += 1
        }
        else{
            cardsShown.append(card)
        }
        if(cardsShown.count == cards.count){
            endGame()
        }
    }
    fileprivate func endGame() {
           isPlaying = false
           delegate?.memoryGameDidEnd(self)
       }
}
