//
//  SignInViewController.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import UIKit
import Firebase
import GoogleSignIn
import NVActivityIndicatorView

class SignInViewController: UIViewController, GIDSignInDelegate, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            print("error during google sign in")
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                // TODO: Handle authentication failure
                print(error?.localizedDescription ?? "")
                return
            }
            DataManager.clearSavedProfiles()
            // Successful Google Sign-in
            // Check if this user has created a profile
            self.startAnimating(type: .circleStrokeSpin, color: .white, backgroundColor: UIColor(named: "Primary")?.withAlphaComponent(0.5))
            DataManager.checkUserHasProfile { (result) in
                self.stopAnimating()
                switch result {
                case .success(let hasProfile):
                    if hasProfile {
                        self.performSegue(withIdentifier: "LoginSuccess", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "CreateProfile", sender: self)
                    }
                case .failure(let error):
                    print(error)
                    self.showNetworkErrorBox()
                    break
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
