//
//  GameCoordinator.swift
//  BlackJack
//
//  Created by Pfriedrix on 12.10.2022.
//

import Foundation

protocol GameCoodinatorDelegate: AnyObject {
    func gameCoodinatorDelegate(state: GameState, startGameFinished: @escaping(Bool) -> Void)
    func gameCoodinatorDelegate(newCard: Card, faceUp: Bool, type: HandType, completion: @escaping () -> Void)
    func gameCoodinatorDelegate(state: GameState)
    func gameCoodinatorDelegate(type: HandType) -> Int
    func gameCoodinatorDelegate(isWinner: GameResult, completion: @escaping () -> Void)
}

protocol GameNavigationButtonsDelegate: AnyObject {
    func makeDeal()
    func makeStand()
    func makeHit()
    func makeDouble()
}

protocol GameHandDeledate: AnyObject {
    func gameHand(score: Int, hand: HandContainerView)
}

class GameCoordinator {
    
    private(set) var state: GameState {
        didSet {
            delegate?.gameCoodinatorDelegate(state: state)
        }
    }
    weak var delegate: GameCoodinatorDelegate?
    
    var gameViewModel = GameViewModel(deck: PlayingCardDeck<Card>())
    
    init () {
        state = .stop
    }
    
    func canStart(summaryBetValue: Double) {
        guard state == .stop || state == .start, summaryBetValue > 0 else {
            state = .stop
            return
        }
        state = .start
    }
    
    func makeDeal() {
        guard state == .start else { return }
        delegate?.gameCoodinatorDelegate(state: state) { [weak self] _ in
            self?.startGame()
        }
    }
    
    func playerFinish(score: Int) {
        guard state == .playing else { return }
        state = .wait
        if score < 21 {
            dealerPlay()
        } else {
            dealerFinish()
        }
    }
    
    func dealerPlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            guard let score = self.delegate?.gameCoodinatorDelegate(type: .dealer), score < 17, let card = self.gameViewModel.getCardFromTop() else {
                self.dealerFinish()
                return
            }
            self.delegate?.gameCoodinatorDelegate(newCard: card, faceUp: true, type: .dealer) {
                self.dealerPlay()
            }
        }
    }
    
    func dealerFinish() {
        guard state == .wait else { return }
        state = .finish
        guard let dealerScore = delegate?.gameCoodinatorDelegate(type: .dealer), let playerScore = delegate?.gameCoodinatorDelegate(type: .player) else { return }
        let result: GameResult = playerScore >= dealerScore ? playerScore == dealerScore ? .draw : .win : .lose
        delegate?.gameCoodinatorDelegate(isWinner: result) { [weak self] in
            self?.state = .start
            print("Finished")
        }
    }
    
    private func startGame() {
        state = .playing
        Array(1...4).forEach { i in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) { [weak self] in
                guard let card = self?.gameViewModel.getCardFromTop() else { return }
                self?.delegate?.gameCoodinatorDelegate(newCard: card, faceUp: i == 4 ? false : true, type: i % 2 == 0 ? .dealer : .player) {
                }
            }
        }
    }
    
    func makeHit() {
        guard state == .playing else { return }
        state = .wait
        guard let card = self.gameViewModel.getCardFromTop() else { return }
        delegate?.gameCoodinatorDelegate(newCard: card, faceUp: true, type: .player) { [weak self] in
            self?.state = .playing
        }
    }
    
    func makeDouble() {
        guard let score = delegate?.gameCoodinatorDelegate(type: .player), state == .playing else { return }
        state = .wait
        if score < 21 {
            dealerPlay()
        } else {
            dealerFinish()
        }
    }
}

enum GameState {
    case stop, start, playing, wait, finish
}

enum HandType: String {
    case player, dealer
}

enum GameResult: String {
    case lose, draw, win
}
