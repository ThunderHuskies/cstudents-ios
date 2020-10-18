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

class CardViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var cardStack: SwipeCardStack!
    private var cardModels: [ProfileCardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CardView Setup
        cardStack = SwipeCardStack()
        cardView.addSubview(cardStack)
        
        // Load dummy data into card models
        cardModels = DataManager.getSampleMatches()
        
        cardStack.anchor(top: cardView.safeAreaLayoutGuide.topAnchor,
                         left: cardView.safeAreaLayoutGuide.leftAnchor,
                         bottom: cardView.safeAreaLayoutGuide.bottomAnchor,
                         right: cardView.safeAreaLayoutGuide.rightAnchor)
        cardStack.delegate = self
        cardStack.dataSource = self
    }
    
    @IBAction func logoutClicked(_ sender: Any!) {
        // TODO: Handle thrown errors
        try! Auth.auth().signOut()
    }
}

// MARK:- CardStack Delegate and DataSource
extension CardViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .up, .right]
        for direction in card.swipeDirections {
            card.setOverlay(CardOverlay(direction: direction), forDirection: direction)
        }
        let model = cardModels[index]
        card.content = CardContentView(withImage: model.image)
        card.footerHeight = 150
        card.footer = CardFooterView(withTitle: "\(model.name)", subtitle: model.major, body: model.schoolName + " ● " +  model.year)
        return card
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
      return cardModels.count
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
      print("Swiped all cards!")
    }

    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
    }

    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        print("Swiped")
    }

    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
      print("Card tapped")
    }
}
