//
//  CardViewController.swift
//  CStudents
//
//  Created by Anshay Saboo on 10/17/20.
//

import Foundation
import UIKit
import Shuffle_iOS
import FirebaseAuth
import NVActivityIndicatorView

class CardViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var cardStack: SwipeCardStack!
    private var cardModels: [ProfileCardModel] = []
    var hasReloaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CardView Setup
        cardStack = SwipeCardStack()
        cardView.addSubview(cardStack)
        
        cardStack.anchor(top: cardView.safeAreaLayoutGuide.topAnchor,
                         left: cardView.safeAreaLayoutGuide.leftAnchor,
                         bottom: cardView.safeAreaLayoutGuide.bottomAnchor,
                         right: cardView.safeAreaLayoutGuide.rightAnchor)
        cardStack.delegate = self
        cardStack.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !hasReloaded {
            hasReloaded = true
            setupCards()
        }
    }
    
    func setupCards() {
        self.startAnimating(type: .circleStrokeSpin, color: .white, backgroundColor: UIColor(named: "Primary")?.withAlphaComponent(0.5))
        DataManager.getMatchesForUser { (res) in
            self.stopAnimating()
            switch res {
            case .success(let profiles):
                self.cardModels = profiles
                self.cardStack.reloadData()
            case .failure(_):
                //self.showNetworkErrorBox()
            print("Error while getting cards")
            }
        }
    }
}

// MARK:- CardStack Delegate and DataSource
extension CardViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .right]
        for direction in card.swipeDirections {
            card.setOverlay(CardOverlay(direction: direction), forDirection: direction)
        }
        let model = cardModels[index]
        card.content = CardContentView(withImage: model.image)
        card.footerHeight = 150
        var emoji = ""
        if model.rating < 0.500 {
            emoji = "☺️"
        } else if model.rating < 0.750 {
            emoji = "😃"
        } else {
            emoji = "😄"
        }
        card.footer = CardFooterView(withTitle: "\(model.name) ● \(emoji)", subtitle: model.major, body: model.schoolName)
        return card
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
      return cardModels.count
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        // TODO: Display pop-up for finishing all cards
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        if direction == .right {
            DataManager.saveProfile(profile: cardModels[index])
        }
    }

    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        let selectedProfile = cardModels[index]
        let profileVC = storyboard?.instantiateViewController(identifier: "ProfileViewController") as! ViewProfileViewController
        profileVC.profile = selectedProfile
        self.present(profileVC, animated: true, completion: nil)
    }
}
