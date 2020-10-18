//
//  Profile.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import Foundation
import UIKit

class ProfileCardModel {
    var name: String?
    var schoolName: String?
    var major: String?
    var year: String?
    var image: UIImage?
    
    init() {}
    
    init(name: String, schoolName: String, major: String, year: String, image: UIImage) {
        self.name = name
        self.schoolName = schoolName
        self.major = major
        self.year = year
        self.image = image
    }
}
