//
//  ChipView.swift
//  BlackJack
//
//  Created by Pfriedrix on 11.10.2022.
//

import UIKit

class ChipView: UIImageView {
    let chip: Chip
    
    var point: CGPoint?
    
    init (_ type: Chip) {
        self.chip = type
        super.init(image: UIImage(named: type.rawValue))
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }
    
    func appear(_ point: CGPoint) {
        self.point = point
        disappear()
        isHidden = false
        transform = CGAffineTransformTranslate(transform, frame.width / 2, frame.height / 2)
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            self?.transform = .identity
        }
    }
    
    func disappear() {
        guard let point = point else { return }
        guard let frame = superview?.convert(frame, to: nil) else { return }
        transform = .init(translationX: -frame.maxX + point.x, y: -frame.maxY + point.y)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
