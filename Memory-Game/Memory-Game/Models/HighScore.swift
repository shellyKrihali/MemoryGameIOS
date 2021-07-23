//
//  HighScore.swift
//  Memory-Game
//
//  Created by user196689 on 7/19/21.
//

import Foundation

class HighScore: Codable{

    
    var id: String
    var name: String
    var timeBest: Int
    var lang: Double
    var lat: Double
    
    init(id: String, name: String, timeBest: Int, lang: Double, lat: Double) {
        self.id = id
        self.name = name
        self.timeBest = timeBest
        self.lang = lang
        self.lat = lat
    }
  
    
}
