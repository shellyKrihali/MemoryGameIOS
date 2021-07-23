//
//  TopTenController.swift
//  Memory-Game
//
//  Created by user196689 on 7/19/21.
//

import UIKit
import MapKit
class TopTenController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var map: MKMapView!
    
    var highScoreManager = HighScoreManager()
    
    var highscores: [HighScore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        highscores = highScoreManager.getHighScores() as [HighScore]
      
    }

}
extension TopTenController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row < highscores.count)
        {
            let score = highscores[indexPath.row]
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude:score.lat,longitude: score.lang )
            annotation.title = "\(indexPath.row + 1). \(score.name)"
            map.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            map.setRegion(region, animated: true)
        }
    }
}
extension TopTenController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
        
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell", for: indexPath)
        if(indexPath.row < highscores.count ){
            let score = highscores[indexPath.row]
            cell.textLabel?.text = "\(indexPath.row + 1). \(score.name)"
        }
        return cell
    }
}
