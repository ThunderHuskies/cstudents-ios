//
//  Cells.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import Foundation
import UIKit

/// Displays a user's profile on the Connections screen
class ConnectionCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    func setup(profile: ProfileCardModel) {
        nameLabel.text = profile.name
        majorLabel.text = profile.major
        schoolLabel.text = profile.schoolName + " ● " + profile.year
        pictureView.image = profile.image
    }
    
    override func layoutSubviews() {
        // Customize appearance
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowOpacity = 0.2
        cardView.clipsToBounds = false
        cardView.layer.cornerRadius = 8.0
        self.clipsToBounds = false
        
        pictureView.layer.cornerRadius = 8.0
        pictureView.clipsToBounds = true
        
    }
}
