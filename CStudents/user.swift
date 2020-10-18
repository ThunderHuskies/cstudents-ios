//
//  user.swift
//  CStudents
//
//  Created by Martin Au-yeung on 2020-10-17.
//

import Foundation
import Firebase

struct User {

  var name: String
  var age: Int
  var school: String
  var major: String
    var courses: Array<String>
  var hobbies: String

  var dictionary: [String: Any] {
    return [
      "name": name,
      "age": age,
      "school": school,
      "major": major,
      "courses": courses,
      "hobbies": hobbies,
    ]
  }
}
extension User: DocumentSerializable {
    
init?(dictionary: [String : Any]) {
  guard let name = dictionary["name"] as? String,
      let age = dictionary["age"] as? Int,
      let school = dictionary["school"] as? String,
      let major = dictionary["major"] as? String,
      let courses = dictionary["courses"] as? Array<String>,
      let hobbies = dictionary["hobbies"] as? String else { return nil }

  self.init(name: name,
            age: age,
            school: school,
            major: major,
            courses: courses,
            hobbies: hobbies)
    
}

}
