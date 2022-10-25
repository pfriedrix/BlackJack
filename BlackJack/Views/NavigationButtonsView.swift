//
//  NavigationButtonsView.swift
//  BlackJack
//
//  Created by Pfriedrix on 11.10.2022.
//

import UIKit

class NavigationButtonView: UIView {
    
    weak var delegate: GameNavigationButtonsDelegate?
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }()
    
    private let dealButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(makeDeal), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(named: "buttonDeal"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let hitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(makeHit), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(named: "buttonHit"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let standButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(makeStand), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(named: "buttonStand"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let doubleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(makeDouble), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(named: "buttonDouble"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    init () {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(buttonsStack)
        addConstraints([
            buttonsStack.topAnchor.constraint(equalTo: topAnchor),
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        buttonsStack.addArrangedSubview(dealButton)
        buttonsStack.addArrangedSubview(hitButton)
        buttonsStack.addArrangedSubview(standButton)
        buttonsStack.addConstraints([
            dealButton.widthAnchor.constraint(equalToConstant: 80),
            dealButton.heightAnchor.constraint(equalToConstant: 40),
            hitButton.widthAnchor.constraint(equalToConstant: 80),
            hitButton.heightAnchor.constraint(equalToConstant: 40),
            standButton.widthAnchor.constraint(equalToConstant: 80),
            standButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc
    private func makeDeal() {
        delegate?.makeDeal()
    }
    
    @objc
    private func makeHit() {
        delegate?.makeHit()
    }
    
    @objc
    private func makeStand() {
        delegate?.makeStand()
    }
    
    @objc
    private func makeDouble() {
        delegate?.makeDouble()
    }
    
    func handleGameState(_ state: GameState) {
        switch state {
        case .stop, .wait, .finish:
            dealButton.isHidden = true
            hitButton.isHidden = true
            standButton.isHidden = true
        case .start:
            dealButton.isHidden = false
            hitButton.isHidden = true
            standButton.isHidden = true
        case .playing:
            dealButton.isHidden = true
            hitButton.isHidden = false
            standButton.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

