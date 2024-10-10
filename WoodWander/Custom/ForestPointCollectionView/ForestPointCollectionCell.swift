//
//  ForestPointCollectionCell.swift
//  WoodWander
//
//  Created by k.zubar on 4.10.24.
//

import UIKit
import SnapKit

final class ForestPointCollectionCell: UICollectionViewCell {
    
    private enum ConstColor {
        static let colorCell: UIColor = .white
        static let colorCellSelected: UIColor = .appGreen.withAlphaComponent(0.25)
    }
    
    private enum ConstFont {
        static let fontCell: UIFont = .appFont.withSize(12.0)
        static let fontCellSelected: UIFont = .appBoldFont.withSize(12.0)
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = ConstFont.fontCell
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool  {
        didSet {
            setSelectedUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with type: String) {
        titleLabel.text = type
    }

    private func setupUI() {
        titleLabel.font = ConstFont.fontCell
        contentView.backgroundColor = ConstColor.colorCell

        contentView.addSubview(titleLabel)
        contentView.setShadow(corRadius: 10.0, shadRadius: 4.0, shadOpacity: 0.05)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setSelectedUI() {
        if isSelected {
            contentView.backgroundColor = ConstColor.colorCellSelected
            titleLabel.font = ConstFont.fontCellSelected

        } else {
            contentView.backgroundColor = ConstColor.colorCell
            titleLabel.font = ConstFont.fontCell
        }
    }
    
}
