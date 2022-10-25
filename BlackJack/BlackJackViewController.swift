//
//  ViewController.swift
//  BlackJack
//
//  Created by Pfriedrix on 11.10.2022.
//

import UIKit

class BlackJackViewController: UIViewController {
    
    private let bg: UIImageView = {
        let bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.image = UIImage(named: "bg-blackjack")
        bg.contentMode = .scaleAspectFill
        return bg
    }()
    
    var summaryBetChipsCoordinator = SummaryBetChipsCoordinator()
    var gameCoordinator = GameCoordinator()
    
    let summaryBetView = SummaryBetChipsView()
    let chipsButtonsView = ChipsButtonsView()
    let navigationButtons = NavigationButtonView()
    let gameDeckView = GameDeckView()
    
    let dealerHand = HandContainerView(type: .dealer)
    let playerHand = HandContainerView(type: .player)
    
    private let moneyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bg)
        view.addConstraints([
            bg.topAnchor.constraint(equalTo: view.topAnchor),
            bg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bg.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        summaryBetChipsCoordinator.delegate = self
        gameCoordinator.delegate = self
        
        chipsButtonsView.delegate = self
        view.addSubview(chipsButtonsView)
        view.addConstraints([
            chipsButtonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            chipsButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(summaryBetView)
        summaryBetView.delegate = self
        view.addConstraints([
            summaryBetView.widthAnchor.constraint(equalToConstant: 50),
            summaryBetView.heightAnchor.constraint(equalToConstant: 50),
            summaryBetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            summaryBetView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(navigationButtons)
        navigationButtons.delegate = self
        view.addConstraints([
            navigationButtons.centerYAnchor.constraint(equalTo: summaryBetView.centerYAnchor),
            navigationButtons.leadingAnchor.constraint(equalTo: summaryBetView.trailingAnchor, constant: 50),
        ])
        
        view.addSubview(moneyLabel)
        view.addConstraints([
            moneyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            moneyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        view.addSubview(gameDeckView)
        view.addConstraints([
            gameDeckView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gameDeckView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            gameDeckView.widthAnchor.constraint(equalToConstant: 70),
            gameDeckView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        view.addSubview(playerHand)
        playerHand.delegate = self
        view.addConstraints([
            playerHand.widthAnchor.constraint(equalToConstant: 70),
            playerHand.heightAnchor.constraint(equalToConstant: 100),
            playerHand.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerHand.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 15)
        ])
        
        view.addSubview(dealerHand)
        dealerHand.delegate = self
        view.addConstraints([
            dealerHand.widthAnchor.constraint(equalToConstant: 70),
            dealerHand.heightAnchor.constraint(equalToConstant: 100),
            dealerHand.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dealerHand.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -15)
        ])
    }
}


extension BlackJackViewController: SummaryBetChipsCoordinatorDelegate {
    func summaryBetChipsCoordinatorDelegate() -> Bool {
        if gameCoordinator.state == .start || gameCoordinator.state == .stop {
            return true
        }
        return false
    }
    
    func summaryBetChipsCoordinatorDelegate(summaryBetValue: Double) {
        moneyLabel.text = "\(UserSavingsService.shared.money)"
        gameCoordinator.canStart(summaryBetValue: summaryBetValue)
    }
    
    func summaryBetChipsCoordinatorDelegate(newChipView chipView: ChipView, from point: CGPoint) {
        summaryBetView.addChip(chipView)
        chipView.appear(point)
    }
    
    func summaryBetChipsCoordinatorDelegate(removedChipView chipView: ChipView) {
        UIView.animate(withDuration: 0.5) {
            chipView.disappear()
        } completion: { _ in
            chipView.removeFromSuperview()
        }
    }
    
    func moveViewsToStartGame() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.summaryBetView.transform = .init(translationX: -self.view.frame.width / 2 + self.summaryBetView.frame.width, y: 0)
            self.chipsButtonsView.transform = .init(translationX: 0, y: self.chipsButtonsView.frame.height * 1.5)
            self.navigationButtons.transform = .init(translationX: -100, y: self.view.frame.height / 2 - self.navigationButtons.frame.height)
        }
    }
    
    func prepareToStart() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.summaryBetView.transform = .identity
            self.chipsButtonsView.transform = .identity
            self.navigationButtons.transform = .identity
        }
    }
}

extension BlackJackViewController: AddBetChipDelegate {
    func addBetChip(_ chip: Chip, from point: CGPoint) {
        summaryBetChipsCoordinator.addChip(chip, from: point)
    }
}

extension BlackJackViewController: RemoveBetChipDelegate {
    func removeBetChip(_ chipView: ChipView, completion: (Bool) -> Void) {
        summaryBetChipsCoordinator.removeChip(chipView, completion: completion)
    }
}

extension BlackJackViewController: GameCoodinatorDelegate {
    func gameCoodinatorDelegate(isWinner: GameResult, completion: @escaping () -> Void) {
        gameDeckView.finish()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.dealerHand.clear()
            self?.playerHand.clear()
            UserSavingsService.shared.money -= Int(self?.summaryBetView.summaryBetValue ?? 0)
            self?.moneyLabel.text = "\(UserSavingsService.shared.money)"
            completion()
        }
    }
    
    func gameCoodinatorDelegate(type: HandType) -> Int {
        switch type {
        case .dealer:
            return dealerHand.score
        case .player:
            return playerHand.score
        }
    }
    
    func gameCoodinatorDelegate(state: GameState) {
        navigationButtons.handleGameState(state)
        
        if state == .playing {
            moveViewsToStartGame()
            gameDeckView.prepareToPlay()
        } else if state == .start {
            prepareToStart()
        }
    }
    
    func gameCoodinatorDelegate(newCard: Card, faceUp: Bool, type: HandType, completion: @escaping () -> Void) {
        switch type {
        case .dealer:
            dealerHand.addCardView(CardView(card: newCard), with: faceUp) { completion() }
        case .player:
            playerHand.addCardView(CardView(card: newCard), with: faceUp) { completion() }
        }
    }
    
    func gameCoodinatorDelegate(state: GameState, startGameFinished: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            startGameFinished(true)
        }
    }
}

extension BlackJackViewController: GameNavigationButtonsDelegate {
    func makeDouble() {
        gameCoordinator.makeDouble()
    }
    
    func makeDeal() {
        gameCoordinator.makeDeal()
    }
    
    func makeStand() {
        dealerHand.showAllCards()
        gameCoordinator.playerFinish(score: playerHand.score)
       
    }
    
    func makeHit() {
        gameCoordinator.makeHit()
    }
}

extension BlackJackViewController: GameHandDeledate {
    func gameHand(score: Int, hand: HandContainerView) {
        if score >= 21 {
            switch hand.type {
            case .player:
                dealerHand.showAllCards()
                gameCoordinator.playerFinish(score: score)
            case .dealer:
                gameCoordinator.dealerFinish()
            }
        }
    }
}
