//
//  SummaryBetChipModel.swift
//  BlackJack
//
//  Created by Pfriedrix on 11.10.2022.
//



enum Chip: String, CaseIterable {
    case chip1 = "Chip-1", chip5 = "Chip-5", chip25 = "Chip-25", chip50 = "Chip-50", chip100 = "Chip-100"
    
    var value: Double {
        switch self {
        case .chip1:
            return 10_000
        case .chip5:
            return 50_000
        case .chip25:
            return 25_000
        case .chip50:
            return 50_000
        case .chip100:
            return 100_000
        }
    }
}
