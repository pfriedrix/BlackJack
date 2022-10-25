//
//  GameDeckView.swift
//  BlackJack
//
//  Created by Pfriedrix on 17.10.2022.
//

import UIKit

class GameDeckView: UIView {
    
    private let deckImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "deck")
        view.contentMode = .redraw
        view.clipsToBounds = true
        return view
    }()

    init () {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(deckImageView)
        addConstraints([
            deckImageView.topAnchor.constraint(equalTo: topAnchor),
            deckImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            deckImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            deckImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        finish()
    }
    
    func finish() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.transform = .init(translationX: 50, y: 0)
        }
    }
    
    func prepareToPlay() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.transform = .identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
