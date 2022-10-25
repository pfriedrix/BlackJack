//
//  CardView.swift
//  BlackJack
//
//  Created by Pfriedrix on 18.10.2022.
//

import UIKit

class CardView: UIView {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .redraw
        view.image = UIImage(named: "cardback")
        return view
    }()
    
    var card: Card {
        didSet {
            imageView.image = faceUp ? UIImage(named: "\(card.rank.shortDescription)\(card.suit.rawValue)") : UIImage(named: "cardback")
        }
    }
    
    var faceUp = false {
        didSet {
            imageView.image = faceUp ? UIImage(named: "\(card.rank.shortDescription)\(card.suit.rawValue)") : UIImage(named: "cardback")
        }
    }
    
    init (card: Card) {
        self.card = card
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpImageView() {
        addSubview(imageView)
        addConstraints([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}


class Card: NSObject {
    enum Suit: String, CaseIterable {
        case Spades = "♠️", Hearts = "♥️", Diamonds = "♦️", Clubs = "♣️"
    }
    
    enum Rank: Int {
        case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
        case Jack, Queen, King, Ace
        
        var shortDescription: String {
            switch self {
            case .Ace:
                return "A"
            case .Jack:
                return "J"
            case .Queen:
                return "Q"
            case .King:
                return "K"
            default:
                return "\(rawValue)"
            }
        }
    }
    
    let rank: Rank, suit: Suit
    
    required init (rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
}

extension Card.Rank {
    struct Values {
        let first: Int, second: Int?
    }
    var values: Values {
        switch self {
        case .Ace:
            return Values(first: 1, second: 11)
        case .Jack, .Queen, .King:
            return Values(first: 10, second: nil)
        default:
            return Values(first: self.rawValue, second: nil)
        }
    }
}
