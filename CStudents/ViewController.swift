//
//  ViewController.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
// Sample new document (data) with generated ID
    // just need to call this to ensure that there is something 
   @IBAction func addData() {
    let collection = Firestore.firestore().collection("users")
    
    let user = User(
        name: "Charlie",
        age: 20,
        school: "school",
        major: "major",
        courses: ["adsf", "1s", "asdf"],
        hobbies: "cheese"
    )
    collection.addDocument(data: user.dictionary)
    
    
    }
}

