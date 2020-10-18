//
//  DataManager.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import Foundation
import UIKit
import FirebaseFirestore

/// Handles all networking functions and communicates with Cloud Firestore API
class DataManager {
    
    let db = Firestore.firestore()
    
    init () {}
    
    public static func getSampleMatches() -> [ProfileCardModel] {
        let models: [ProfileCardModel] = [
            ProfileCardModel(name: "Janica Smith", schoolName: "University of Washington", major: "Liberal Studies", year: "2nd Year", image: UIImage(named: "TestProfileImage")!),
            ProfileCardModel(name: "Sam Johnson", schoolName: "University of Washington", major: "Computer Science", year: "3rd Year", image: UIImage(named: "TestProfileImage-1")!),
            ProfileCardModel(name: "Janica Smith", schoolName: "University of Washington", major: "Liberal Studies", year: "2nd Year", image: UIImage(named: "TestProfileImage")!),
            ProfileCardModel(name: "Janica Smith", schoolName: "University of Washington", major: "Liberal Studies", year: "2nd Year", image: UIImage(named: "TestProfileImage")!)
          ]
        return models
    }
}
