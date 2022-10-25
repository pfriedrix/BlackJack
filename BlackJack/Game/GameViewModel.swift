//
//  GameViewModel.swift
//  BlackJack
//
//  Created by Pfriedrix on 18.10.2022.
//


class GameViewModel {
    var cards: [Card]
    
    init(deck: PlayingCardDeck<Card>) {
        cards = deck.cards
        cards.shuffle()
    }
    
    func getCardFromTop() -> Card? {
        if !cards.isEmpty {
            return cards.removeLast()
        }
        
        return nil
    }
}


class PlayingCardDeck<T: Card> {
    var cards: [T]
    
     init() {
        self.cards = [T]()
         for rawSuit in T.Suit.allCases  {
            for rawRank in 2...14 {
                self.cards.append(T(rank: T.Rank(rawValue: rawRank)!, suit: rawSuit))
            }
        }
    }
}
