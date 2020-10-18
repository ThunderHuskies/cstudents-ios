//
//  ConnectionsViewController.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import UIKit
import Alertift
import Toast_Swift

class ConnectionsViewController: UIViewController {
    
    @IBOutlet weak var connectionsTableView: UITableView!
    
    var profiles: [ProfileCardModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView setup
        connectionsTableView.delegate = self
        connectionsTableView.dataSource = self
        
        profiles = DataManager.getSavedProfiles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profiles = DataManager.getSavedProfiles()
        connectionsTableView.reloadData()
    }
    
    func showActivitySheet(index: Int) {
        let selected = profiles[index]
        Alertift.actionSheet(title: "Connect", message: "Contact " + selected.name)
            .action(.default("Email")) { (_, _) in
                UIApplication.shared.open(URL(string: "mailto:" + selected.email)!)
            }
            .action(.default("LinkedIn")) { (_, _) in
                if selected.linkedInURL.isEmpty {
                    self.view.makeToast(selected.name + " doesn't have LinkedIn right now!")
                    return
                }
                UIApplication.shared.open(URL(string: selected.linkedInURL)!)
            }
            .action(.default("Instagram")) { (_, _) in
                if selected.instagramHandle.isEmpty {
                    self.view.makeToast(selected.name + " doesn't have Instagram right now!")
                    return
                }
                UIApplication.shared.open(URL(string: "https://www.instagram.com/" + selected.instagramHandle)!)
            }
            .show(on: self, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActivitySheet(index: indexPath.row)
    }
    
}
