//
//  HighScoreManager.swift
//  Memory-Game
//
//  Created by user196689 on 7/19/21.
//

import Foundation
class HighScoreManager{
    func insertHighScore(highScore: HighScore){
        print(highScore.timeBest)
        var highscores = getHighScores().sorted{
            $0.timeBest < $1.timeBest
        }
        if (highscores.count == 10){
            highscores.remove(at: 9)
        }
        highscores.append(highScore)
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(highscores)
            UserDefaults.standard.set(data, forKey: "HighScore")
        }
        catch{
            print("error")
        }
    }
    
    func getHighScores() -> [HighScore]{

        if let data = UserDefaults.standard.data(forKey: "HighScore"){
            do {
                let decoder = JSONDecoder()
                let highScores = try decoder.decode([HighScore].self, from: data)
              
                return highScores.sorted(){
                    $0.timeBest < $1.timeBest
                }
                    
            }catch{
                print("error")
            }
        }
        
        return []
    }
    func checkIfHighScore(time: Int) -> Bool{
        let highscores = getHighScores().sorted{
            $0.timeBest < $1.timeBest
        }
        if(highscores.count < 10){
            return true
        } else{
            if(highscores[9].timeBest > time){
                return true
            }
        }
        return false
    }
}
