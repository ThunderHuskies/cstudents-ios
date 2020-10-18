//
//  ViewController.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "showApp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showApp" {
            // Customize the TabBarController
            let tabBarController: UITabBarController = segue.destination as! UITabBarController
            // Tab bar customization
            tabBarController.tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
            tabBarController.tabBar.standardAppearance.shadowColor = nil
            tabBarController.tabBar.standardAppearance.shadowImage = UIImage().withTintColor(.clear)
            tabBarController.tabBar.clipsToBounds = true
            tabBarController.selectedIndex = 1
        }
    }


}

