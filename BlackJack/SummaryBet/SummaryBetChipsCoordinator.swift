//
//  SupmmaryBetChipsCoordinator.swift
//  BlackJack
//
//  Created by Pfriedrix on 11.10.2022.
//

import Combine
import UIKit

protocol SummaryBetChipsCoordinatorDelegate: AnyObject {
    func summaryBetChipsCoordinatorDelegate(newChipView chipView: ChipView, from point: CGPoint)
    func summaryBetChipsCoordinatorDelegate(removedChipView chipView: ChipView)
    func summaryBetChipsCoordinatorDelegate(summaryBetValue: Double)
    func summaryBetChipsCoordinatorDelegate() -> Bool
}

protocol AddBetChipDelegate: AnyObject {
    func addBetChip(_ chip: Chip, from point: CGPoint)
}

protocol RemoveBetChipDelegate: AnyObject {
    func removeBetChip(_ chipView: ChipView, completion: (Bool) -> Void)
}

class SummaryBetChipsCoordinator {
    
    weak var delegate: SummaryBetChipsCoordinatorDelegate?
    private var summaryBetChipsViewModel: SummaryBetChipsViewModel
    
    var store = Set<AnyCancellable>()

    init () {
        summaryBetChipsViewModel = SummaryBetChipsViewModel()
        summaryBetChipsViewModel.$chips
            .sink { [weak self] chips in
                guard let self = self else { return }
                let summaryBetValue = chips.reduce(0.0, {$0 + $1.value})
                self.delegate?.summaryBetChipsCoordinatorDelegate(summaryBetValue: summaryBetValue)
            }
            .store(in: &store)
    }
    
    func addChip(_ chip: Chip, from point: CGPoint) {
        guard let delegate = delegate, delegate.summaryBetChipsCoordinatorDelegate() else { return }
        guard Double(UserSavingsService.shared.money) >= chip.value else { return }
        UserSavingsService.shared.money -= Int(chip.value)
        summaryBetChipsViewModel.chips.append(chip)
        let chipView = ChipView(chip)
        delegate.summaryBetChipsCoordinatorDelegate(newChipView: chipView, from: point)
    }
    
    func removeChip(_ chipView: ChipView, completion: (Bool) -> Void) {
        guard let delegate = delegate, delegate.summaryBetChipsCoordinatorDelegate() else { return }
        guard let index = summaryBetChipsViewModel.chips.firstIndex(of: chipView.chip) else {
            completion(false)
            return
        }
        UserSavingsService.shared.money += Int(chipView.chip.value)
        completion(true)
        summaryBetChipsViewModel.chips.remove(at: index)
        delegate.summaryBetChipsCoordinatorDelegate(removedChipView: chipView)
    }
}
