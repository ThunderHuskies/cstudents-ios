//
//  Profile.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import Foundation
import UIKit
import SwiftyJSON

class ProfileCardModel {
    var uid = ""
    var name: String = ""
    var schoolName: String = ""
    var major: String = ""
    var image: UIImage? = nil
    var age = 0
    var clubs = ""
    var courses: [String] = []
    var email = ""
    var hobbies = ""
    var hometown = ""
    var instagramHandle = ""
    var linkedInURL = ""
    var rating = 0.0
    private var rawDict: [String:Any] = [:]
    
    init() {}
    
    init(name: String, schoolName: String, major: String, image: UIImage) {
        self.name = name
        self.schoolName = schoolName
        self.major = major
        self.image = image
    }
    
    convenience init(json: JSON) {
        let rawDict = json.dictionaryObject!
        self.init(dict: rawDict)
        self.rawDict = rawDict
    }
    
    convenience init(data: Data) {
        let dict = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [String:Any]
        self.init(dict: dict)
    }
    
    init(dict: [String:Any]) {
        uid = dict["uid"] as! String
        name = dict["name"] as! String
        schoolName = dict["school"] as! String
        major = dict["major"] as! String
        age = dict["age"] as! Int
        email = dict["email"] as! String
        hometown = dict["hometown"] as! String
        rating = dict["rating"] as! Double
        
        if let clubs = dict["clubs"] as? String {
            self.clubs = clubs
        }
        
        if let hobbies = dict["hobbies"] as? String {
            self.hobbies = hobbies
        }
        
        if let instagramHandle = dict["instagramHandle"] as? String {
            self.instagramHandle = instagramHandle
        }
        
        if let linkedInURL = dict["linkedinURL"] as? String {
            self.linkedInURL = linkedInURL
        }
        
        if let courses = dict["courses"] as? [String] {
            self.courses = courses
        }
        
        if let image = dict["image"] as? UIImage {
            self.image = image
        }
    }
    
    public func convertToStorable() -> Data {
        rawDict["image"] = self.image
        return NSKeyedArchiver.archivedData(withRootObject: rawDict)
    }

    
    public static func convertArrayToStorable(profiles: [ProfileCardModel]) -> [Data] {
        var data: [Data] = []
        for profile: ProfileCardModel in profiles {
            data.append(profile.convertToStorable())
        }
        return data
    }
    
    public static func convertDataToObjects(datas: [Data]) -> [ProfileCardModel] {
        var profiles: [ProfileCardModel] = []
        for data: Data in datas {
            profiles.append(ProfileCardModel(data: data))
        }
        return profiles
    }
    
    
}
