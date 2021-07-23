//
//  GameController.swift
//  Memory-Game
//
//  Created by user196689 on 7/17/21.
//

import UIKit
import CoreLocation
class GameController: UIViewController {
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var counterLabel: UILabel!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

    let game = MemoryGame()
    var cards = [Card]()
    var counter :Int = 0
    var timer = Timer()
    let location = CLLocationManager()
    var lng: Double = 0.0
    var lat: Double = 0.0
    var highScoreManager = HighScoreManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.location.requestAlwaysAuthorization()

        // For use in foreground
        self.location.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            location.delegate = self
            location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            location.startUpdatingLocation()
        }
        
        game.delegate = self
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        
        
        let manager = Manager()
        manager.getCardImages{(cardsArray, error) in
            if let _ = error{
                //show alert
            }
            self.counterLabel.text = String(self.game.count)

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
    func showHighScoreDialog(){
        let dialog = UIAlertController(title: "New Highscore!", message: "Please enter your name:", preferredStyle: .alert)
        let timerCounter = self.counter
        let submitAction = UIAlertAction(title: "Submit", style: .default) { UIAlertAction in
        let name = dialog.textFields![0].text
        let highScore = HighScore(id: UUID().uuidString, name: name ?? "UnNamed", timeBest: timerCounter, lang: self.lng, lat: self.lat)
                  self.highScoreManager.insertHighScore(highScore: highScore)
                self.showEndDialog()
              }
        submitAction.isEnabled = false
               dialog.addTextField { textField in
                   NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { _ in
                       let textCounter = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                       let textIsNotEmpty = textCounter > 0
                       submitAction.isEnabled = textIsNotEmpty
                   }
    }
        dialog.addAction(submitAction)
        present(dialog, animated: true, completion: nil)
    }
    func showEndDialog(){
        let alertController = UIAlertController(
                  title: "Good job!",
                  message: "Want to play again?",
                  preferredStyle: .alert)
              
              let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] (action) in
                self?.collectionView.isHidden = true
                self?.navigationController?.popToRootViewController(animated: true)              }
              let playAgainAction = UIAlertAction(title: "Yes!", style: .default) { [weak self] (action) in
                  self?.collectionView.isHidden = false
                  self?.resetGame()
              }
              
              alertController.addAction(cancelAction)
              alertController.addAction(playAgainAction)
              
              self.present(alertController, animated: true) { }
    }
    func setupNewGame(){
        counter = 0
        self.counterLabel.text = String(self.game.count)

        cards = game.newGame(cardsArray: self.cards)
        collectionView.reloadData()
    }
    func resetGame(){
        counter = 0
        self.counterLabel.text = String(self.game.count)

        game.restartGame()
        setupNewGame()
    }
 
    @IBAction func startGameTapped(_ sender: Any) {
        collectionView.isHidden = false
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    @objc func timerAction() {
        let minutes = counter / 60 % 60
        let seconds = counter % 60
        timerLabel.text = String(format: "%02i:%02i", minutes, seconds)
          counter += 1
        self.counterLabel.text = String(self.game.count)
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
        
        timer.invalidate()
        if(highScoreManager.checkIfHighScore(time: counter)){
            self.showHighScoreDialog()
        } else{
            self.showEndDialog()

        }
        resetGame()
    }
  
}
  
extension GameController: UICollectionViewDelegateFlowLayout {
    
    // Collection view flow layout setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * 4
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / 4
     
        
        return CGSize(width: widthPerItem, height: widthPerItem + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
extension GameController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.lat = locValue.latitude
        self.lng = locValue.longitude
      
    }
}
    
   
    

