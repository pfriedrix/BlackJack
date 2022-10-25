//
//  HandContrainerView.swift
//  BlackJack
//
//  Created by Pfriedrix on 17.10.2022.
//

import UIKit

class HandContainerView: UIView {
    
    let type: HandType
    var state: HandState = .inactive
    
    weak var delegate: GameHandDeledate?
    
    var isAnimating = false {
        didSet {
            scoreLabel.alpha = score > 0 && !isAnimating ? 1 : 0
            scoreLabel.text = "\(score)"
        }
    }
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var cards = [CardView]() {
        didSet {
            updateCards()
        }
    }
    
    var containsAce: Bool {
        for card in cards.filter({ $0.faceUp }) {
            if card.card.rank.values.second != nil {
                return true
            }
        }
        return false
    }
    
    var rawValue: Int {
        cards.filter { $0.faceUp }.reduce(0, {$0 + $1.card.rank.values.first})
    }
    
    var score: Int {
        if containsAce && rawValue <= 11 {
            return rawValue + 10
        }
        return rawValue
    }
    
    init(type: HandType) {
        self.type = type
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        addSubview(scoreLabel)
        addConstraints([
            scoreLabel.topAnchor.constraint(equalTo: topAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        scoreLabel.transform = .init(translationX: 0, y: -60)
    }
    
    private func updateCards() {
        scoreLabel.alpha = score > 0 && !isAnimating ? 1 : 0
        scoreLabel.text = "\(score)"
        delegate?.gameHand(score: score, hand: self)
    }
    
    func addCardView(_ cardView: CardView, with faceUp: Bool, completion: @escaping () -> Void ) {
        guard state != .inactive else { return }
       
        addSubview(cardView)
        addConstraints([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        if let last = cards.last {
            addConstraints([
                cardView.leadingAnchor.constraint(equalTo: last.leadingAnchor, constant: 20),
                cardView.trailingAnchor.constraint(equalTo: last.trailingAnchor, constant: 20),
            ])
        } else {
            addConstraints([
                cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
                cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
        
        cards.append(cardView)
        displayCard(cardView, with: faceUp) { [weak self] in
            completion()
            self?.updateCards()
        }
    }
    
    func showAllCards() {
        cards.filter { !$0.faceUp }.enumerated().forEach { index, card in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1) {
                UIView.transition(with: card, duration: 0.4, options: [.curveEaseOut, .transitionFlipFromLeft]) {
                    card.faceUp = true
                } completion: { [weak self] _ in
                    self?.updateCards()
                }
            }
        }
    }
    
    func clear() {
        cards.forEach { _ in
            let card = cards.removeFirst()
            UIView.animate(withDuration: 0.7) { [weak self] in
                guard let window = self?.window else { return }
                card.transform = .init(translationX: 0, y: -window.frame.height)
            } completion: { _ in
                card.removeFromSuperview()
            }
        }
    }
    
    private func displayCard(_ cardView: CardView, with faceUp: Bool, completion: @escaping () -> Void) {
        guard let frame = superview?.convert(frame, to: nil), let window = window else { return }
        let offset = CGFloat(20 * (cards.count + 1))
        let x = -frame.maxX + window.bounds.width - offset - 22
        let y = -frame.midY + window.bounds.height / 2 + 7
        cardView.transform = .init(translationX: x, y: y)
        isAnimating = true
        UIView.animate(withDuration: 0.5) {
            cardView.transform = CGAffineTransformTranslate(cardView.transform, -50, 0)
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                cardView.transform = .identity
            } completion: { _ in
                UIView.transition(with: cardView, duration: 0.4, options: [.curveEaseOut, .transitionFlipFromLeft]) {
                    cardView.faceUp = faceUp
                } completion: { [weak self] _ in
                    self?.isAnimating = false
                    completion()
                }
            }
        }
    }
}

enum HandState {
    case inactive, active, insurance, double, split
}
