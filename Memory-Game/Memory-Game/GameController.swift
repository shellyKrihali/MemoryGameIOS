//
//  GameController.swift
//  Memory-Game
//
//  Created by user196689 on 7/17/21.
//

import UIKit

class GameController: UIViewController {
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var counterLabel: UILabel!
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

    let game = MemoryGame()
    var cards = [Card]()
    var counter :Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        let manager = Manager()
        manager.getCardImages{(cardsArray, error) in
            if let _ = error{
                //show alert
            }
            self.counterLabel.text = String(self.counter)
            self.cards = cardsArray!
            self.setupNewGame()
        }
    
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if(game.isPlaying){
            resetGame()
        }
    }
    
    func setupNewGame(){
        counter = 0
        self.counterLabel.text = String(self.counter)
        cards = game.newGame(cardsArray: self.cards)
        collectionView.reloadData()
    }
    func resetGame(){
        counter = 0
        self.counterLabel.text = String(self.counter)
        game.restartGame()
        setupNewGame()
    }
 
    @IBAction func startGameTapped(_ sender: Any) {
        collectionView.isHidden = false
    }
}
    
    extension GameController: UICollectionViewDelegate, UICollectionViewDataSource{
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return cards.count
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
            cell.showCard(false, animated: false)
            guard let card = game.cardAtIndex(indexPath.item) else{ return cell}
            cell.card = card
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let cell = collectionView.cellForItem(at: indexPath) as! CardCell
            if cell.shown { return }
            game.didSelectCard(cell.card)
            collectionView.deselectItem(at: indexPath, animated: true)
            	
        }
        
    }
extension GameController: MemoryGameProtocol{
    func memoryGameDidStart(_ game: MemoryGame) {
        collectionView.reloadData()
    }
    func memoryGame(_ game: MemoryGame, showCards cards: [Card]) {
        
           for card in cards {
               guard let index = game.indexForCard(card) else { continue }
               let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
            cell.showCard(true, animated: true)
           }
        
       }
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
            cell.showCard(false, animated: true)
        }
    }
    
    func memoryGameDidEnd(_ game: MemoryGame) {
        let alertController = UIAlertController(
                  title: "Good job, Memory Master!",
                  message: "Want to play again?",
                  preferredStyle: .alert)
              
              let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] (action) in
                  self?.collectionView.isHidden = true
              }
              let playAgainAction = UIAlertAction(title: "Yes!", style: .default) { [weak self] (action) in
                  self?.collectionView.isHidden = false
                  self?.resetGame()
              }
              
              alertController.addAction(cancelAction)
              alertController.addAction(playAgainAction)
              
              self.present(alertController, animated: true) { }
              
              resetGame()
    }
  
}
  
extension GameController: UICollectionViewDelegateFlowLayout {
    
    // Collection view flow layout setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * 4
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / 4
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
    
   
    

