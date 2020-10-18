//
//  DataManager.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import Alamofire
import SwiftyJSON
import FirebaseStorage

/// Handles all networking functions and communicates with Cloud Firestore API
class DataManager {
    
    static let db = Firestore.firestore()
    static let datastore = UserDefaults.standard
    
    init () {
        
    }
    
    /// Temporary helper function that generates dummy profiles to display
    public static func getSampleMatches() -> [ProfileCardModel] {
        let models: [ProfileCardModel] = [
            ProfileCardModel(name: "Janica Smith", schoolName: "University of Washington", major: "Liberal Studies", image: UIImage(named: "TestProfileImage")!),
            ProfileCardModel(name: "Sam Johnson", schoolName: "University of Washington", major: "Computer Science", image: UIImage(named: "TestProfileImage-1")!),
            ProfileCardModel(name: "Janica Smith", schoolName: "University of Washington", major: "Liberal Studies", image: UIImage(named: "TestProfileImage")!),
            ProfileCardModel(name: "Janica Smith", schoolName: "University of Washington", major: "Liberal Studies", image: UIImage(named: "TestProfileImage")!)
          ]
        return models
    }
    
    /// Saves the user's information to the database
    public static func updateUserInformation(data: [String : Any], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.authenticationError))
            return
        }
        db.collection("users").document(userId).setData(data) { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(.failure(.networkFailure))
                return
            }
            // Successful user update
            completion(.success(true))
        }
    }
    
    /// Check if the user has already created a profile
    public static func checkUserHasProfile(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.authenticationError))
            return
        }
        db.collection("users").document(userId).getDocument { (document, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(.failure(.networkFailure))
                return
            }
            if let document = document, document.exists {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        }
    }
    
    /// Get the current user's profile
    public static func getCurrentUserProfile(completion: @escaping (Result<[String:Any?], NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.authenticationError))
            return
        }
        db.collection("users").document(userId).getDocument { (document, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(.failure(.networkFailure))
                return
            }
            if let document = document, document.exists {
                var data = document.data()!
                self.getCurrentProfileImage { (res) in
                    switch res {
                    case .success(let image):
                        data["image"] = image
                        completion(.success(data))
                    case .failure(_):
                        completion(.failure(.networkFailure))
                        return
                    }
                }
            } else {
                completion(.failure(.recordDoesNotExist))
            }
        }
    }
    
    // Get the current user's matches
    public static func getMatchesForUser(completion: @escaping (Result<[ProfileCardModel], NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.authenticationError))
            return
        }
        AF.request("https://cstudents.herokuapp.com/matches", method: .get, parameters: ["uid": userId]).responseJSON { (response) in
            if response.error != nil && response.response?.statusCode != 200 {
                print(response.error?.localizedDescription)
                completion(.failure(.networkFailure))
                return
            }
            let json = try! JSON(data: response.data!).array!
            var profiles: [ProfileCardModel] = []
            
            let group = DispatchGroup()
            
            for userJSON: JSON in json {
                let profile = ProfileCardModel(json: userJSON)
                print(profile.uid)
                group.enter()
                self.getImageForUID(UID: profile.uid) { (res) in
                    switch res {
                    case .success(let image):
                        profile.image = image
                        profiles.append(profile)
                    case .failure(_): break
                        //completion(.failure(.networkFailure))
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(.success(profiles))
                return
            }
        }
    }
    
    // Get current user's profile picture
    public static func getCurrentProfileImage(completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.authenticationError))
            return
        }
        let storage = Storage.storage()
        let imageRef = storage.reference(withPath: "profileImages/" + userId + ".png")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 1 * 1024 * 1024 * 30) { data, error in
            if error != nil {
            completion(.failure(.networkFailure))
          } else {
            let image = UIImage(data: data!)
            completion(.success(image!))
          }
        }
    }
    
    // Save current user's profile picture
    public static func saveCurrentProfileImage(image: UIImage, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.authenticationError))
            return
        }
        let storage = Storage.storage()
        let imageRef = storage.reference(withPath: "profileImages/" + userId + ".png")
        let data = image.pngData()!
        
        _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            completion(.failure(.networkFailure))
            return
          }
            completion(.success(true))
        }
    }
    
    // Get the image for a given UID
    public static func getImageForUID(UID: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let storage = Storage.storage()
        let imageRef = storage.reference(withPath: "profileImages/" + UID + ".png")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 1 * 1024 * 1024 * 30) { data, error in
            if error != nil {
            completion(.failure(.networkFailure))
          } else {
            let image = UIImage(data: data!)
            completion(.success(image!))
          }
        }
    }
    
    public static func saveProfile(profile: ProfileCardModel) {
        if var profileData = datastore.object(forKey: "SavedProfiles") as? [Data] {
            profileData.append(profile.convertToStorable())
            datastore.setValue(profileData, forKey: "SavedProfiles")
        } else {
            datastore.setValue([profile.convertToStorable()], forKey: "SavedProfiles")
        }
    }
    
    public static func getSavedProfiles() -> [ProfileCardModel] {
        if let profileData = datastore.object(forKey: "SavedProfiles") as? [Data] {
            return ProfileCardModel.convertDataToObjects(datas: profileData)
        } else {
            return []
        }
    }
    
    public static func clearSavedProfiles() {
        datastore.setValue([], forKey: "SavedProfiles")
    }
    
    
}

enum NetworkError: Error {
    case networkFailure
    case authenticationError
    case recordDoesNotExist
}
