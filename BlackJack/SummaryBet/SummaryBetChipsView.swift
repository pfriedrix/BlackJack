//
//  SummaryBetChipsView.swift
//  BlackJack
//
//  Created by Pfriedrix on 11.10.2022.
//

import UIKit

class SummaryBetChipsView: UIView {
    
    weak var delegate: RemoveBetChipDelegate?
    
    private var chips = [ChipView]() {
        didSet {
            summaryBetLabel.alpha = summaryBetValue > 0 ? 1 : 0
            summaryBetLabel.text = String(format: "%.0f", summaryBetValue)
        }
    }
    
    var summaryBetValue: Double {
        chips.reduce(0.0, {$0 + $1.chip.value})
    }
    
    private let summaryBetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    init () {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(resetAllChips))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeLastChip)))
    }
    
    override func didMoveToSuperview() {
        addSubview(summaryBetLabel)
        addConstraints([
            summaryBetLabel.topAnchor.constraint(equalTo: topAnchor),
            summaryBetLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            summaryBetLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            summaryBetLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        summaryBetLabel.transform = .init(translationX: 0, y: -50)
    }
    
    func addChip(_ chip: ChipView) {
        chips.append(chip)
        addSubview(chip)
        addConstraints([
            chip.topAnchor.constraint(equalTo: topAnchor),
            chip.leadingAnchor.constraint(equalTo: leadingAnchor),
            chip.trailingAnchor.constraint(equalTo: trailingAnchor),
            chip.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func clear() {
        guard !chips.isEmpty else { return }
        chips.enumerated().reversed().forEach { index, chip in
            self.delegate?.removeBetChip(chip) { [weak self] success in
                _  = success ? self?.chips.removeLast() : nil
            }
        }
    }
    
    @objc
    private func removeLastChip() {
        guard let last = chips.last else { return }
        
        delegate?.removeBetChip(last) { [weak self] success in
            _  = success ? self?.chips.removeLast() : nil
        }
    }
    
    @objc
    private func resetAllChips() {
        chips.enumerated().reversed().forEach { index, chip in
            self.delegate?.removeBetChip(chip) { [weak self] success in
                _  = success ? self?.chips.removeLast() : nil
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
