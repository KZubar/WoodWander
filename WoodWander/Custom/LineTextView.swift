//
//  LineTextView.swift
//  WoodWander
//
//  Created by k.zubar on 30.07.24.
//

import UIKit
import SnapKit

@objc protocol LineTextViewPotocol: AnyObject {
    
    @objc optional func lineTextView(_ lineTextView: LineTextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String
    ) -> Bool

    @objc optional func lineTextViewDidChangeSelection(_ lineTextView: LineTextView)
    
    @objc optional func lineTextViewDidEndEditing(_ lineTextView: LineTextView)
    
    @objc optional func lineTextViewDidBeginEditing(_ lineTextView: LineTextView)
}

final class LineTextView: UIView {
    
    // MARK: - private

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appBoldFont.withSize(13.0)
        label.textColor = .mainFont
        label.textAlignment = .left
        return label
    }()

    private lazy var textView: UITextView = {
        let txtView = UITextView()
        txtView.delegate = self
        txtView.font = .appFont.withSize(15.0)
        txtView.textColor = .mainFont
        txtView.textAlignment = .left
        txtView.autocorrectionType = .yes
        txtView.autocapitalizationType = .sentences
        txtView.tintColor = .appBlack
        txtView.backgroundColor = .appWhite
        return txtView
    }()
    
    private lazy var separatorLeft: UIView = {
        let view = UIView()
        view.backgroundColor = .appBlack
        return view
    }()
    private lazy var separatorRight: UIView = {
        let view = UIView()
        view.backgroundColor = .appBlack
        return view
    }()
    private lazy var separatorTop: UIView = {
        let view = UIView()
        view.backgroundColor = .appBlack
        return view
    }()
    private lazy var separatorBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .appBlack
        return view
    }()

    // MARK: - public
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var keyboardType: UIKeyboardType? {
        get { textView.keyboardType }
        set { textView.keyboardType = newValue ?? UIKeyboardType.default }
    }
    var textContentType: UITextContentType? {
        get { textView.textContentType }
        set { textView.textContentType = newValue }
    }
    var autocorrectionType: UITextAutocorrectionType {
        get { textView.autocorrectionType }
        set { textView.autocorrectionType = newValue }
    }
    var autocapitalizationType: UITextAutocapitalizationType {
        get { textView.autocapitalizationType }
        set { textView.autocapitalizationType = newValue }
    }
    var returnKeyType: UIReturnKeyType {
        get { textView.returnKeyType }
        set { textView.returnKeyType = newValue }
    }
    var isEditable: Bool {
        get { textView.isEditable }
        set { textView.isEditable = newValue }
    }
    var isSelectable: Bool {
        get { textView.isSelectable }
        set { textView.isSelectable = newValue }
    }

    var text: String? {
        get { textView.text }
        set { textView.text = newValue }
    }

    var textColor: UIColor? {
        get { textView.textColor }
        set { textView.textColor = newValue }
    }

    var defaultText: String = "Введите комментарий"
    var defaultCollor: UIColor = .appBlack
    var editCollor: UIColor = .appBlack

    weak var delegat: LineTextViewPotocol?

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
        
        addSubview(textView)
        
        addSubview(separatorLeft)
        addSubview(separatorRight)
        addSubview(separatorTop)
        addSubview(separatorBottom)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(15.0)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8.0)
            make.horizontalEdges.equalToSuperview().inset(4.0)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(4.0)
        }
        separatorTop.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-4.0)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        separatorBottom.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).inset(-4.0)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        separatorLeft.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-4.0)
            make.bottom.equalTo(textView.snp.bottom).inset(-4.0)
            make.width.equalTo(1)
        }
        separatorRight.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-4.0)
            make.bottom.equalTo(textView.snp.bottom).inset(-4.0)
            make.width.equalTo(1)
        }
    }
}

extension LineTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String
    ) -> Bool {
        return delegat?.lineTextView?(self,
                                      shouldChangeTextIn: range,
                                      replacementText: text) ?? true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        delegat?.lineTextViewDidChangeSelection?(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegat?.lineTextViewDidEndEditing?(self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegat?.lineTextViewDidBeginEditing?(self)
    }
    
}


extension LineTextView {
    
    public func setDefaultText() {
        if let txt = textView.text {
            if txt.isEmpty || txt == defaultText {
                self.textView.text = self.defaultText
                self.textView.textColor = self.defaultCollor
            } else {
                self.textView.text = txt
                self.textView.textColor = self.editCollor
            }
        }
    }
    
    public func setEditingText() {
        if let txt = textView.text {
            if txt.isEmpty || txt == self.defaultText {
                textView.text = ""
                textView.textColor = self.editCollor
            }
        }
    }
    
    public func getText() -> String {
        guard
            let txt = textView.text
        else { return "" }

        return (txt == self.defaultText) ? "" : txt
    }

}

