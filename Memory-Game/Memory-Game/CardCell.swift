//
//  CardCell.swift
//  Memory-Game
//
//  Created by user196689 on 7/17/21.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var frontImageView: UIImageView!
    
    var card: Card?{
        didSet{
            guard let card = card else {return}
            frontImageView.image = card.artWork
            frontImageView.layer.cornerRadius = 5.0
            backImageView.layer.cornerRadius = 5.0
            
            frontImageView.layer.masksToBounds = true
            backImageView.layer.masksToBounds = true
        }
    }
    var shown : Bool = false
    
    func showCard(_ show: Bool, animated: Bool){
        frontImageView.isHidden = false
        backImageView.isHidden = false
        if (animated){
        if(show){
            UIView.transition(from: backImageView, to: frontImageView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: {(finished: Bool) -> () in})
        }
        else{
            UIView.transition(from: frontImageView, to: backImageView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: {(finished: Bool) -> () in})
        }
        }
        else{
            if(show){
                bringSubviewToFront(frontImageView)
                backImageView.isHidden = true
                
            }
            else{
                bringSubviewToFront(backImageView)
                frontImageView.isHidden = true
            }
        }
    }
}
