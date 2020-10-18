//
//  ViewProfileViewController.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/18/20.
//

import UIKit

class ViewProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var profile: ProfileCardModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = profile.name
        majorLabel.text = profile.major
        schoolLabel.text = profile.schoolName
        imageView.image = profile.image

        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-DemiBold", size: 16)!, .foregroundColor: UIColor.black]
        let regAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Avenir Next", size: 15)!, .foregroundColor: UIColor.black]

        let mainString = NSMutableAttributedString()
        
        if !(profile?.courses.isEmpty)! {
            let course = NSMutableAttributedString(string: "Courses\n", attributes: boldAttributes)
            var names = ""
            for course: String in profile.courses {
                names += course + ", "
            }
            course.append(NSMutableAttributedString(string: names, attributes: regAttributes))
            mainString.append(course)
        }
        
        if !(profile.hobbies.isEmpty) {
            let title = NSMutableAttributedString(string: "\n\nHobbies\n", attributes: boldAttributes)
            title.append(NSMutableAttributedString(string: profile.hobbies, attributes: regAttributes))
            mainString.append(title)
        }
        
        if !(profile.clubs.isEmpty) {
            let title = NSMutableAttributedString(string: "\n\nClubs & Organizations\n", attributes: boldAttributes)
            title.append(NSMutableAttributedString(string: profile.clubs, attributes: regAttributes))
            mainString.append(title)
        }
        
        bodyTextView.attributedText = mainString
        
    }
}
