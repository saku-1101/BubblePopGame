//
//  HighScoreViewController.swift
//  BubblePopGame
//
//  Created by Sakura Adachi 17/4/23.
//

import UIKit

class HighScoreViewController: UIViewController {

    @IBOutlet weak var highScoreTableView: UITableView!
    
    let userDefaults = UserDefaults()
    var namescore = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Helper.shared.string(forKey: "playerName") == nil {
            Helper.shared.set("Default", forKey: "playerName")
        }
        if !Helper.shared.dictionary(forKey: "highscorePeople").isEmpty {
            namescore = Helper.shared.dictionary(forKey: "highscorePeople") as! [String : Int]
        }

    }
    
    // needed?
    @IBAction func returnMainPage(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension HighScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namescore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell", for: indexPath)
        
        let sortedOne = namescore.sorted { (first, second) -> Bool in
            return first.value > second.value
        }

        cell.textLabel?.text = "\(sortedOne[indexPath.row].key)"
        cell.detailTextLabel?.text = "\(sortedOne[indexPath.row].value)"
        
        return cell
    }
}
