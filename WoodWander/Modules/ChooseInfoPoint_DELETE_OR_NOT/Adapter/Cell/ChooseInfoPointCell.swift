////
////  ChooseInfoPointCell.swift
////  WoodWander
////
////  Created by k.zubar on 4.10.24.
////
//
//import UIKit
//import SnapKit
//import Storage
//import SwiftIcons
//
//protocol ChooseCategoriesPointCellProtocol: AnyObject {
//    func tableViewUpdates()
//    func descrTextViewDidChange(dto: (any DTODescriptionCategoriesPoint)?,
//                                descr: String?)
//}
//
//final class ChooseCategoriesPointCell: UITableViewCell {
//    
//    private enum Icon {
//        static let radioButtonUnchecked = UIImage.Categories.radioButtonUnchecked
//        static let radioButtonChecked = UIImage.Categories.radioButtonChecked
//        static let formatListBulleted = UIImage.Categories.formatListBulleted
//    }
//
//    
//    
//    
//    
//    private lazy var iconLabel: UILabel = {
//        let label = UILabel()
//        label.font = .appFont.withSize(20.0)
//        label.textAlignment = .center
//        //label.backgroundColor = .appWhite
//        return label
//    }()
//
//    private lazy var moreButton: UIButton = {
//        let bttn = UIButton()
//        bttn.setIcon(
//            icon: Icon.radioButtonUnchecked,
//            iconSize: 16,
//            color: .appBlueLight,
//            //backgroundColor: .appWhite,
//            forState: .normal)
//        return bttn
//    }().withAction(self, #selector(moreButtonDidTap), for: .touchUpInside)
//
//    private lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .appFont.withSize(14)
//        label.textColor = .mainFont
//        //label.backgroundColor = .appWhite
//        return label
//    }()
//
//    private lazy var infoTextView: UITextView = {
//        let textView = UITextView()
//        textView.cornerRadius = 10.0
//        textView.setBorder(width: 1.0, color: .systemGray3)
//        textView.font = .appFont.withSize(10.0)
//        textView.textColor = .mainFont
//        textView.textAlignment = .left
//        textView.autocorrectionType = .yes
//        textView.autocapitalizationType = .sentences
//        textView.isScrollEnabled = false
//        textView.delegate = self
//        textView.backgroundColor = .appWhite
//        textView.isSelectable = true
//        textView.keyboardDismissMode = .onDrag
//        return textView
//    }()
//
//    
//    weak var delegate: ChooseCategoriesPointCellProtocol?
//    
//    private var indexPath: IndexPath = IndexPath()
//
//    var buttonDidTap: ((_ dto: (any DTODescriptionCategoriesPoint)?,
//                        _ check: Bool) -> Void)?
//    
//    var descrTextViewDidChange: ((_ dto: (any DTODescriptionCategoriesPoint)?,
//                                  _ descr: String) -> Void)?
//    
//    var originalTextViewHeight: CGFloat = 0 // Исходную высоту UITextView
//    var maxTextViewHeight: CGFloat = 100 // Максимальная высота UITextView
//    var textViewHeightConstraint: Constraint?
//    
//    private var dto: (any DTODescriptionCategoriesPoint)?
//    private var check: Bool? {
//        didSet {
//            
//            guard let checkValue = check else { return }
//            
//            //установим иконку "выбора"
//            let checkIcon = checkValue
//                ? Icon.radioButtonChecked
//                : Icon.radioButtonUnchecked
//
//            moreButton.setIcon(
//                icon: checkIcon,
//                iconSize: 20,
//                color: .appBlue,
//                //backgroundColor: .appWhite,
//                forState: .normal)
//
//            //управляем содержимым textview
//            if checkValue == false {
//                infoTextView.resignFirstResponder()
//            }
//
//            if checkValue == true {
//                adjustTextViewHeight()
//            } else {
//                textViewHeightConstraint?.update(offset: 0)
//            }
//            
//            UIView.animate(withDuration: 0.1) {
//                self.contentView.layoutIfNeeded()
//            }
//            
//            //управляем видимостью textview
//            self.infoTextView.isHidden = !checkValue
//        }
//    }
//
//    
//    
//    
//    
//    override init(style: UITableViewCell.CellStyle,
//                  reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        setupUI()
//        setupConstraints()
//    }
//    
//    
//    func setupCell(
//        _ dto: (any DTODescriptionCategoriesPoint),
//        check: Bool,
//        indexPath: IndexPath
//    ) {
//        
//        self.dto = dto
//        self.check = check
//        self.indexPath = indexPath
//
//        self.titleLabel.text = dto.name
//        self.titleLabel.textColor = .mainFont
//        self.infoTextView.text = dto.descr
//
//        self.iconLabel.text = dto.icon
//        if (self.iconLabel.text ?? "").isEmpty {
//            self.iconLabel.setIcon(icon: Icon.formatListBulleted,
//                                   iconSize: CGFloat(20.0),
//                                   color: .appBlue)
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("\(Self.self) was called by coder")
//    }
//    
//    private func setupUI() {
//        self.selectionStyle = .none
//        
//        contentView.addSubview(iconLabel)
//        contentView.addSubview(moreButton)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(infoTextView)
//
//        // Установите начальную высоту UITextView
//        let maxSize = CGSize(width: infoTextView.frame.width,
//                             height: CGFloat.greatestFiniteMagnitude)
//        let size = infoTextView.sizeThatFits(maxSize)
//        self.originalTextViewHeight = size.height
//        
//        
//        // Вычислите высоту для пяти строк текста
//        let lineHeight = infoTextView.font?.lineHeight ?? 0
//        self.maxTextViewHeight = lineHeight * 7
//        
//        // Установите отступы для текста
//        let textContainer = infoTextView.textContainerInset
//        infoTextView.textContainerInset = UIEdgeInsets(
//            top: textContainer.top,
//            left: textContainer.left + 5,
//            bottom: textContainer.bottom,
//            right: textContainer.right + 5
//        )
//        
//
//    }
//    
//    private func setupConstraints() {
//        iconLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(8)
//            make.leading.equalToSuperview().offset(4)
//            make.width.equalTo(30)
//            make.height.equalTo(30)
//        }
//        moreButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(8)
//            make.trailing.equalToSuperview().offset(-4)
//            make.width.equalTo(30)
//            make.height.equalTo(30)
//        }
//        titleLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(moreButton.snp.centerY)
//            make.leading.equalTo(iconLabel.snp.trailing).offset(4)
//            make.trailing.equalTo(moreButton.snp.leading).offset(-4)
//        }
//        infoTextView.snp.makeConstraints { make in
//            make.top.equalTo(moreButton.snp.bottom).offset(8)
//            make.leading.equalTo(titleLabel.snp.leading)
//            make.trailing.equalToSuperview().offset(-8)
//            textViewHeightConstraint = make.height.equalTo(originalTextViewHeight).constraint
//            make.bottom.equalToSuperview().inset(8).priority(.low)
//        }
//     }
//
//    @objc func moreButtonDidTap(sender: UIView) {
//        if let check = self.check {
//            let newValue = !check
//            self.check = newValue
//            buttonDidTap?(dto, newValue)
//            self.delegate?.tableViewUpdates()
//        }
//    }
//    
//    private func adjustTextViewHeight() {
//        let maxSize = CGSize(width: infoTextView.frame.width,
//                             height: CGFloat.greatestFiniteMagnitude)
//        let size = infoTextView.sizeThatFits(maxSize)
//        
//        if size.height > maxTextViewHeight {
//            infoTextView.isScrollEnabled = true
//            textViewHeightConstraint?.update(offset: maxTextViewHeight)
//        } else {
//            infoTextView.isScrollEnabled = false
//            textViewHeightConstraint?.update(offset: size.height)
//        }
//    }
//
//}
//
//
//extension ChooseCategoriesPointCell: UITextViewDelegate {
//    
//    func textViewDidChange(_ textView: UITextView) {
//        
//        adjustTextViewHeight()
//        
//        UIView.animate(withDuration: 0.1) {
//            self.contentView.layoutIfNeeded()
//        }
//
//        self.delegate?.descrTextViewDidChange(dto: dto, descr: textView.text)
//        self.delegate?.tableViewUpdates()
//    }
//    
//    //Начало редактирования
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        infoTextView.layer.borderColor = UIColor.appBlue.cgColor
//    }
//
//    //Конец редактирования
//    func textViewDidEndEditing(_ textView: UITextView) {
//        infoTextView.layer.borderColor = UIColor.systemGray3.cgColor
//    }
//}
