//
//  CreateCategoriesPointVC.swift
//  WoodWander
//
//  Created by k.zubar on 23.08.24.
//

import UIKit
import SnapKit
import MCEmojiPicker
import SwiftIcons

final class CreateCategoriesPointVC: UIViewController {
    
    private enum Icon {
        static let closeRound: FontType = UIImage.Categories.closeRound
    }
    
    private enum Color {
        static let defaultByPicker: UIColor = .defaultByMarker
    }

    private lazy var contentView: UIView = .setContentView()
    private lazy var welcomLabel: UILabel = {
        let label: UILabel = .welcomTitle("Новый список")
        if self.viewModel.name?.isEmpty == false {
            label.text = "Изменение списка"
        }
        return label
    }()
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let bttn = UIButton()
        bttn.setTitle("СОХРАНИТЬ", for: .normal)
        bttn.titleLabel?.font = .appFont.withSize(14.0)
        bttn.setTitleColor(.systemGray3, for: .selected)
        bttn.setTitleColor(.systemGray3, for: .normal) //по умолчанию
        bttn.isEnabled = false // по умолчанию
        bttn.backgroundColor = .appWhite
        return bttn
    }().withAction(viewModel,
                   #selector(CreateCategoriesPointViewModelProtocol.createDidTap),
                   for: .touchUpInside)
    
    private lazy var cancelButton: UIButton = {
        let bttn = UIButton()
        bttn.setIcon(
            icon: Icon.closeRound,
            iconSize: 20,
            color: .appBlack,
            forState: .normal)
        return bttn
    }().withAction(viewModel,
                   #selector(CreateCategoriesPointViewModelProtocol.dismissDidTap),
                   for: .touchUpInside)
    
    private lazy var nameTextView: InputDataTextField = {
        let textField = InputDataTextField()
        textField.delegat = self
        textField.borderColor = .appBlue
        textField.borderGray = .systemGray5
        textField.placeHolder = "Укажите название списка"
        textField.constPlaceHolder = "Укажите название списка"
        textField.placeHolderColor = .systemGray2
        return textField
    }()
    
    private lazy var descrTextView: InputDataTextField = {
        let textField = InputDataTextField()
        textField.delegat = self
        textField.borderColor = .appBlue
        textField.borderGray = .systemGray5
        textField.placeHolder = "Добавьте описание списка"
        textField.constPlaceHolder = "Добавьте описание списка"
        textField.placeHolderColor = .systemGray2
        return textField
    }()
    
    private lazy var iconContentView: EmojiPickerBigView = {
        let view = EmojiPickerBigView()
        view.delegat = self
        return view
    }()
    
    private lazy var colorContentView: ColorPickerBigView = {
        let view = ColorPickerBigView()
        view.colorDefault = Color.defaultByPicker
        view.colorUser = Color.defaultByPicker
        view.delegat = self
        return view
    }()

//TODO: - viewModel
    private var viewModel: CreateCategoriesPointViewModelProtocol
    
    private var iconUser: String = "" {
        didSet {
            iconContentView.iconUser = iconUser
            viewModel.icon = iconUser
            //setupSaveButton(!(viewModel.icon ?? "").isEmpty)
        }
    }
    
    private var colorUser: UIColor = Color.defaultByPicker {
        didSet {
            colorContentView.colorUser = colorUser
            viewModel.color = colorUser.rgbToHex()
        }
    }

    init(viewModel: CreateCategoriesPointViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
                
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    private func bind() {       
        self.descrTextView.text = viewModel.descr
        self.nameTextView.text = viewModel.name
        
        self.iconUser = viewModel.icon ?? ""
       
        var color: UIColor = Color.defaultByPicker
        if let colorString = viewModel.color {
            if !colorString.isEmpty {
                color = UIColor.hexToRGB(hexStr: colorString)
            }
        }
        self.colorUser = color
        
        self.setupSaveButton(!(viewModel.name ?? "").isEmpty)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .appWhite
        
        self.view.addSubview(self.contentView)
        
        self.contentView.addSubview(self.welcomLabel)
        self.contentView.addSubview(self.cancelButton)
        self.contentView.addSubview(self.saveButton)
        self.contentView.addSubview(self.infoView)
        
        self.infoView.addSubview(self.iconContentView)
        self.infoView.addSubview(self.colorContentView)
        self.infoView.addSubview(self.nameTextView)
        self.infoView.addSubview(self.descrTextView)
    }
    
    private func setupConstraints() {
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        //in contentView
        welcomLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalToSuperview().inset(8)
        }
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(welcomLabel.snp.centerY)
            make.left.equalToSuperview().inset(16)
        }
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(welcomLabel.snp.centerY)
            make.right.equalToSuperview().inset(16)
        }
        infoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(welcomLabel.snp.bottom).inset(-32.0)
            make.bottom.equalToSuperview()
        }
        
        //in infoView
        iconContentView.snp.makeConstraints { make in
            make.top.equalTo(-16)
            make.right.equalTo(infoView.snp.centerX).inset(8.0)
            make.height.width.equalTo(160)
        }
        colorContentView.snp.makeConstraints { make in
            make.top.equalTo(-16)
            make.left.equalTo(infoView.snp.centerX).inset(8.0)
            make.height.width.equalTo(160)
         }
        nameTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(iconContentView.snp.bottom).inset(-16.0)
        }
        descrTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(nameTextView.snp.bottom).inset(-16.0)
        }
    }
    
    //включает или выключает кнопку (меняет цвет надписи)
    private func setupSaveButton(_ isEnabled: Bool) {
        if saveButton.isEnabled != isEnabled {
            saveButton.isEnabled = isEnabled
            let colorButton: UIColor = isEnabled ? .appBlack : .systemGray3
            saveButton.setTitleColor(colorButton, for: .normal)
        }
    }

    @objc private func tapGestureDone() {
        view.endEditing(true)
    }
    
}

extension CreateCategoriesPointVC: MCEmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
         self.iconUser = emoji
    }
}

extension CreateCategoriesPointVC: EmojiPickerBigViewProtocol {
    func clearEmoji() {
         self.iconUser = ""
    }
    func openPickerEmoji(sourceView: UIView) {
        let viewController = MCEmojiPickerViewController()
        viewController.delegate = self
        viewController.sourceView = sourceView
        present(viewController, animated: true)
    }
}

extension CreateCategoriesPointVC: ColorPickerBigViewProtocol {
    func clearColor() {
         self.colorUser = Color.defaultByPicker
    }
    func openPickerColor(selectedColor: UIColor) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Выберите цвет метки"
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        colorPicker.selectedColor = selectedColor
        self.present(colorPicker, animated: true, completion: nil)
    }
}

//UIColorPicker сообщает о выборе цвета
extension CreateCategoriesPointVC: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colorUser = viewController.selectedColor
    }
}

extension CreateCategoriesPointVC: InputDataTextFieldPotocol {

    //Сообщает делегату об изменении выделения текста в указанном текстовом поле.
    func inputDataTextFieldDidChangeSelection(_ inputDataTextField: InputDataTextField) {
        if inputDataTextField == self.nameTextView {
            viewModel.name = inputDataTextField.text
            setupSaveButton(!(viewModel.name ?? "").isEmpty)
        } else if inputDataTextField == self.descrTextView {
            viewModel.descr = inputDataTextField.text
        }
    }
    
    func inputDataTextFieldDidEndEditing(_ inputDataTextField: InputDataTextField) {
        if inputDataTextField == self.nameTextView {
            viewModel.name = inputDataTextField.text
            setupSaveButton(!(viewModel.name ?? "").isEmpty)
        } else if inputDataTextField == self.descrTextView {
            viewModel.descr = inputDataTextField.text
        }
    }
    
    //Вызывается, когда пользователь нажимает кнопку возврата на клавиатуре
    func inputDataTextFieldShouldReturn(_ inputDataTextField: InputDataTextField) -> Bool {
        inputDataTextField.textFieldResignFirstResponder()
        return true
    }
    
}

