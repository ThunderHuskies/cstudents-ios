//
//  NewProfileViewController.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/18/20.
//

import UIKit
import Eureka
import Toast_Swift
import NVActivityIndicatorView

class NewProfileViewController: FormViewController, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Validation rules
        TextRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        PhoneRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        EmailRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        IntRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        ImageRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.textLabel?.textColor = .red
            }
        }
        PushRow<String>.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.textLabel?.textColor = .red
            }
        }
        
        
        // Create form
        form +++ Section("Basic Info")
            <<< TextRow("name") {
                $0.title = "Name"
                $0.placeholder = "Ex. Janica Miller"
                $0.add(rule: RuleRequired())
            }
            <<< PhoneRow("phone") {
                $0.title = "Phone Number"
                $0.add(rule: RuleRequired())
                $0.placeholder = "1234567890"
                $0.add(rule: RuleExactLength(exactLength: 10))
            }
            <<< EmailRow("email") {
                $0.title = "Email Address"
                $0.add(rule: RuleEmail())
                $0.add(rule: RuleRequired())
            }
            <<< IntRow("age") {
                $0.title = "Age"
                $0.placeholder = "Ex. 18"
                $0.add(rule: RuleRequired())
            }
            <<< TextRow("hometown") {
                $0.title = "Hometown"
                $0.placeholder = "Ex. Seattle"
                $0.add(rule: RuleRequired())
            }
            <<< ImageRow("image") {
                $0.title = "Select a picture"
                $0.add(rule: RuleRequired())
            }
            
            +++ Section("Education")
            <<< PushRow<String>("school") {
                $0.title = "School"
                $0.selectorTitle = "Select your school"
                $0.options = ["University of British Columbia", "University of California Irvine", "University of Washington, Seattle"]
                $0.add(rule: RuleRequired())
            }
            <<< TextRow("major") {
                $0.title = "Major"
                $0.placeholder = "Ex. Oceanography"
                $0.add(rule: RuleRequired())
            }
            
            +++ Section("Clubs and Organizations")
            <<< TextAreaRow("clubs") {
                $0.placeholder = "Ex. DubHacks, Film Club, Mock Trial"
            }
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Courses",
                                   footer: "Ex. CSE 143, PSYCH 240") {
                    $0.addButtonProvider = { section in
                        return ButtonRow(){
                            $0.title = "Add New Course"
                        }
                    }
                    $0.multivaluedRowToInsertAt = { index in
                        return TextRow("Course_\(index)") {
                            $0.placeholder = "Enter Course Code"
                            $0.add(rule: RuleRequired())
                        }
                    }
                    $0 <<< TextRow("Course_0") {
                        $0.placeholder = "Enter Course Code"
                        $0.add(rule: RuleRequired())
                    }
                }
            
            +++ Section("Hobbies")
                <<< TextAreaRow("hobbies") {
                    $0.placeholder = "Ex. Surfing, eating, watching anime"
                }
            
            +++ Section("Social")
            <<< TextRow("linkedinURL") {
                $0.placeholder = "linkedin.com/"
                $0.title = "LinkedIn URL"
            }
            <<< TextRow("instagramHandle") {
                $0.placeholder = "@example"
                $0.title = "Instagram"
            }
    }
    
    
    // Handle form submission
    @IBAction func saveClicked(_ sender: Any) {
        let errors = form.validate()
        if !errors.isEmpty {
            var style = ToastStyle()
            style.backgroundColor = .red
            self.view.makeToast(errors.first?.msg, duration: 3.0, style: style)
            return
        }
        
        print(form.values())
        saveUserData()
    }
    
    // Save the user details
    func saveUserData() {
        var values = form.values()
        var courses: [String] = []
        for i in 0...20 {
            let key = "Course_\(i)"
            if (values[key] != nil) {
                courses.append(values[key] as! String)
                values.removeValue(forKey: key)
            }
        }
        
        values["courses"] = courses
        let image = values["image"] as! UIImage
        values.removeValue(forKey: "image")
        self.startAnimating(type: .circleStrokeSpin, color: .white, backgroundColor: UIColor(named: "Primary")?.withAlphaComponent(0.5))
        DataManager.updateUserInformation(data: values) { (result) in
            switch result {
            case .success(_):
                DataManager.saveCurrentProfileImage(image: image) { (res) in
                    self.stopAnimating()
                    switch res {
                    case .success(_):
                        self.performSegue(withIdentifier: "ProfileCreated", sender: self)
                    case .failure(_):
                        self.showNetworkErrorBox()
                        break;
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
