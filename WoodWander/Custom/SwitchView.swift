//
//  SwitchView.swift
//  WoodWander
//
//  Created by k.zubar on 30.07.24.
//

import UIKit
import SnapKit

@objc protocol SwitchViewProtocol: AnyObject {
    @objc optional func onClickSwitch(_ sender: SwitchView)
}

final class SwitchView: UIView {
    
    // MARK: - private
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appBoldFont.withSize(13.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .mainFont
        label.textAlignment = .left
        return label
    }()
    private lazy var controlSwitch: UISwitch = {
        let swch = UISwitch()
        swch.onTintColor = .switchTintColor
        //swch.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 200)
        swch.addTarget(self, action: #selector(onClickSwitch(sender:)), for: UIControl.Event.valueChanged)
        return swch
    }()
    
    private lazy var viewSwitch = UIView()

    
    // MARK: - public
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var isOn: Bool {
        get { controlSwitch.isOn }
        set { controlSwitch.isOn = newValue }
    }
    
    weak var delegat: SwitchViewProtocol?

    // MARK: - init()
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        self.addSubview(titleLabel)
        self.addSubview(viewSwitch)
        self.viewSwitch.addSubview(controlSwitch)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.right.equalTo(viewSwitch.snp.left)
        }
        viewSwitch.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        controlSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
    
    @objc private func onClickSwitch(sender: UISwitch) {
        delegat?.onClickSwitch?(self)
    }
}

