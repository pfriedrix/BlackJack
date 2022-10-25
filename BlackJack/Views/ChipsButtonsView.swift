//
//  ChipsButtonsView.swift
//  BlackJack
//
//  Created by Pfriedrix on 11.10.2022.
//

import UIKit

class ChipsButtonsView: UIView {
    
    weak var delegate: AddBetChipDelegate?
    
    private let chipsStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        Chip.allCases.forEach { name in
            
            let button = UIButton()
            button.accessibilityIdentifier = name.rawValue
            button.contentMode = .scaleAspectFit
            button.setImage(UIImage(named: name.rawValue), for: .normal)
            button.addTarget(nil, action: #selector(handleTapChip), for: .touchUpInside)
            
            stack.addArrangedSubview(button)
            stack.addConstraints([
                button.heightAnchor.constraint(equalToConstant: 50),
                button.widthAnchor.constraint(equalToConstant: 50),
            ])
        }
        
        return stack
    }()

    
    @objc
    private func handleTapChip(_ sender: Any) {
        guard let button = sender as? UIButton, let chip = Chip(rawValue: button.accessibilityIdentifier ?? "") else { return }
        guard var point = superview?.convert(frame.origin, from: nil) else { return }
        point.x += button.frame.maxX
        point.y += button.frame.maxY
        delegate?.addBetChip(chip, from: point)
    }
    
    init () {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(chipsStack)
        addConstraints([
            chipsStack.topAnchor.constraint(equalTo: topAnchor),
            chipsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            chipsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            chipsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
