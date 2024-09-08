//
//  LineTextField.swift
//  WoodWander
//
//  Created by k.zubar on 30.07.24.
//

import UIKit
import SnapKit

@objc protocol LineTextFieldPotocol: AnyObject {
    
    @objc optional func lineTextField(_ lineTextField: LineTextField,
                                      shouldChangeCharactersIn range: NSRange,
                                      replacementString string: String
    ) -> Bool
    
    @objc optional func lineTextFieldDidChangeSelection(_ lineTextField: LineTextField)
    
    @objc optional func lineTextFieldDidEndEditing(_ lineTextField: LineTextField)
    
}

final class LineTextField: UIView {
    
    // MARK: - private

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appBoldFont.withSize(13.0)
        label.textColor = .mainFont
        label.textAlignment = .left
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .none
        textField.font = .appFont.withSize(15.0)
        textField.textColor = .mainFont
        textField.textAlignment = .left
        return textField
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .mainFont
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .appBoldFont.withSize(12.0)
        label.textColor = .appRed
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - public
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var titleColor: UIColor? {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }
    var errorText: String? {
        get { errorLabel.text }
        set { errorLabel.text = newValue }
    }
    var textColor: UIColor? {
        get { textField.textColor }
        set { textField.textColor = newValue }
    }
    var placeHolder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }
    var placeHolderColor: UIColor? {
        get { UIColor() }
        set {
            guard
                let newColor = newValue,
                let textPlaceholder = textField.attributedPlaceholder?.string
            else { return }
            let attributes = [NSAttributedString.Key.foregroundColor: newColor]
            let attributedPlaceholder = NSAttributedString(
                string: textPlaceholder,
                attributes: attributes
            )
            textField.attributedPlaceholder = attributedPlaceholder
        }
    }

    
    var keyboardType: UIKeyboardType? {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue ?? UIKeyboardType.default }
    }
    var textContentType: UITextContentType? {
        get { textField.textContentType }
        set { textField.textContentType = newValue }
    }
    var isSecureTextEntry: Bool? {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue ?? false}
    }
    var autocorrectionType: UITextAutocorrectionType {
        get { textField.autocorrectionType }
        set { textField.autocorrectionType = newValue }
    }
    var autocapitalizationType: UITextAutocapitalizationType {
        get { textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }
    var returnKeyType: UIReturnKeyType {
        get { textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }

    
    
    

    override var inputView: UIView? {
        get { textField.inputView }
        set { textField.inputView = newValue }
    }
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    weak var delegat: LineTextFieldPotocol?
    
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
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(separator)
        addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.horizontalEdges.equalToSuperview()
        }
        separator.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).inset(-4.0)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        errorLabel.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).inset(-4.0)
        }

    }
}

extension LineTextField: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegat?.lineTextFieldDidChangeSelection?(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegat?.lineTextFieldDidEndEditing?(self)
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        return delegat?.lineTextField?(self,
                                       shouldChangeCharactersIn: range,
                                       replacementString: string) ?? true
    }
    
}
