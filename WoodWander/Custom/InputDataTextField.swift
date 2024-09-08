//
//  InputDataTextField.swift
//  WoodWander
//
//  Created by k.zubar on 25.08.24.
//

import UIKit
import SnapKit

@objc protocol InputDataTextFieldPotocol: AnyObject {
    
    @objc optional func inputDataTextField(_ inputDataTextField: InputDataTextField,
                                      shouldChangeCharactersIn range: NSRange,
                                      replacementString string: String
    ) -> Bool
    
    @objc optional func inputDataTextFieldDidChangeSelection(_ inputDataTextField: InputDataTextField)
    
    @objc optional func inputDataTextFieldDidEndEditing(_ inputDataTextField: InputDataTextField)
    
    @objc optional func inputDataTextFieldShouldReturn(_ inputDataTextField: InputDataTextField) -> Bool
   
    @objc optional func inputDataTextFieldShouldClear(_ inputDataTextField: InputDataTextField) -> Bool

}

final class InputDataTextField: UIView {
    
    // MARK: - private

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .none
        textField.font = .appFont.withSize(16.0)
        textField.textColor = .mainFont
        textField.textAlignment = .left
        return textField
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.cornerRadius = 10.0
        view.setBorder(width: 1.5, color: .systemGray3)
        return view
    }()

    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    // MARK: - public

    var textColor: UIColor? {
        get { textField.textColor }
        set { textField.textColor = newValue }
    }
    
    var placeHolder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }
    var constPlaceHolder: String?
    
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

    var borderColor: UIColor = UIColor.clear
    var borderGray: UIColor = UIColor.clear
    
    

    override var inputView: UIView? {
        get { textField.inputView }
        set { textField.inputView = newValue }
    }
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    weak var delegat: InputDataTextFieldPotocol?
    
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
        self.addSubview(contentView)
        self.addSubview(separator)
        self.contentView.addSubview(textField)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.height.equalTo(40)
        }
        separator.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).inset(-24.0)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }


        textField.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.horizontalEdges.equalToSuperview().inset(16.0)
        }
    }
    
//    private func setBorder(_ color: UIColor) {
//        contentView.layer.borderColor = color.cgColor
//    }
    
    func textFieldResignFirstResponder() {
        textField.resignFirstResponder()
    }
}

extension InputDataTextField: UITextFieldDelegate {
    
    //Сообщает делегату об изменении выделения текста в указанном текстовом поле.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegat?.inputDataTextFieldDidChangeSelection?(self)
    }
    
    //Начало редактирования
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setParamTextField(isEditing: false)
    }

    //Конец редактирования
    func textFieldDidEndEditing(_ textField: UITextField) {
        setParamTextField(isEditing: true)
        delegat?.inputDataTextFieldDidEndEditing?(self)
    }
    
    //Всякий раз, когда текущий текст изменяется, он вызывает метод и публикует уведомление.
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        return delegat?.inputDataTextField?(self,
                                            shouldChangeCharactersIn: range,
                                            replacementString: string) ?? true
    }
    
    //Вызывается, когда пользователь нажимает кнопку возврата на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegat?.inputDataTextFieldShouldReturn?(self) ?? true
    }
    
    //Вызывается, когда пользователь нажимает встроенную кнопку, чтобы очистить текст
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return delegat?.inputDataTextFieldShouldClear?(self) ?? true
    }
    
    private func setParamTextField(isEditing: Bool) {
        if isEditing {
            self.contentView.layer.borderColor = self.borderGray.cgColor
            if let txt = self.text {
                if txt.isEmpty {
                    self.placeHolder = self.constPlaceHolder
                }
            }
        } else {
            self.contentView.layer.borderColor = self.borderColor.cgColor
            self.placeHolder = ""
        }
    }

}
