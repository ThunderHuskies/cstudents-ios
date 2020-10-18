//
//  ConnectionsViewController.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import UIKit

class ConnectionsViewController: UIViewController {
    
    @IBOutlet weak var connectionsTableView: UITableView!
    
    var profiles: [ProfileCardModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView setup
        connectionsTableView.delegate = self
        connectionsTableView.dataSource = self
        
        profiles = DataManager.getSampleMatches()
    }

}

// MARK:- TableView Delegate and Data Source
extension ConnectionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionCell", for: indexPath) as! ConnectionCell
        cell.setup(profile: profiles[indexPath.row])
        return cell
    }
    
}
