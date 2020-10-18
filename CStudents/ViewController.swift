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
    func addData() {
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "name": "name",
            "age":0,
            "school": "The University of British Columbia",
        ]) { err in
            if let err = err {
                print("error: \(err) ")
            } else {
                print("added: \(ref!.documentID)")
            }
        }
    }
}

