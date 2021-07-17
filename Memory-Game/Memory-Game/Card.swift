//
//  Card.swift
//  Memory-Game
//
//  Created by user196689 on 7/17/21.
//
import Foundation
import UIKit
class Card{
    var id :String
    var shown : Bool = false
    var artWork  = UIImage()
    static var allCards = [Card]()
    
    init(card: Card){
        self.id = card.id
        self.shown = card.shown
        self.artWork = card.artWork
    }
    init(image: UIImage){
        self.id = NSUUID().uuidString
        self.shown = false
        self.artWork = image
    }
    func equals(_ card: Card) -> Bool {
          return (card.id == id)
      }
      
      func copy() -> Card {
          return Card(card: self)
      }
}
extension Array {
    mutating func shuffle() {
        for _ in 0...self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
