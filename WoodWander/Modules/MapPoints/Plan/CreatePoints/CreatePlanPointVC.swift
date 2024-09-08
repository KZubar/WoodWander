//
//  CreatePlanPointVC.swift
//  WoodWander
//
//  Created by k.zubar on 29.07.24.
//

import Foundation
import UIKit

protocol CreatePlanPointViewModelProtocol: AnyObject {     
    var point: PlanPointDescription? { get set }

    func dismissDidTap()
    func createDidTap()
}



final class CreatePlanPointVC: UIViewController {
    
    private lazy var contentView: UIView = .setContentView()
    private lazy var welcomLabel: UILabel = .labelTitle17("Новое местоположение")
    private lazy var infoView: UIView = .setInfoView()

    private lazy var nameTextField: LineTextField = {
        let textField = LineTextField()
        textField.delegat = self
        textField.title = "Имя:"
        textField.placeHolder = "Назовем как-нибудь"
        textField.placeHolderColor = .secondaryFont
        textField.textColor = .appBlue
        textField.titleColor = .appBlack
        return textField
    }()

    private lazy var latitudeTextField: LineTextField = {
        let textField = LineTextField()
        textField.delegat = self
        textField.title = "Широта:"
        textField.placeHolder = ""
        textField.placeHolderColor = .secondaryFont
        textField.textColor = .appBlue
        textField.titleColor = .appBlack
        return textField
    }()

    private lazy var longitudeTextField: LineTextField = {
        let textField = LineTextField()
        textField.delegat = self
        textField.title = "Долгота:"
        textField.placeHolder = ""
        textField.placeHolderColor = .secondaryFont
        textField.textColor = .appBlue
        textField.titleColor = .appBlack
       return textField
    }()

    private lazy var descriptionTextView: LineTextView = {
        let textView = LineTextView()
        textView.delegat = self
        textView.title = "Описание"
        textView.defaultText = "Описание"
        textView.backgroundColor = .appWhite
        textView.isSelectable = true
        textView.defaultCollor = .appBlue
        textView.editCollor = .appRed
        
        return textView
    }()

    private lazy var picView: UIView = {
        let view = UIView()
        view.backgroundColor = .appYellowAlpha
        return view
    }()
    
    private lazy var createButton: UIButton =
        .yellowRoundedButton("Создать")
        .withAction(self, #selector(createDidTap))
    
    private lazy var cancelButton: UIButton =
        .cancelYellowButton()
        .withAction(self, #selector(dismissDidTap))

    
    
    private var viewModel: CreatePlanPointViewModelProtocol

    init(viewModel: CreatePlanPointViewModelProtocol) {
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.locationView.image = viewModel.screenshotImage
    }

    private func bind() {
        
        self.nameTextField.text = viewModel.point?.name
        self.descriptionTextView.text = viewModel.point?.descr
        if let latitude = viewModel.point?.latitude {
            self.latitudeTextField.text = "\(latitude)"
        }
        if let longitude = viewModel.point?.longitude {
            self.longitudeTextField.text = "\(longitude)"
        }
        self.descriptionTextView.setDefaultText()

        let tapGestureViewDone = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
        self.view.addGestureRecognizer(tapGestureViewDone)

        let tapGestureViewColor = UITapGestureRecognizer(target: self, action: #selector(tapGestureColor))
        self.picView.addGestureRecognizer(tapGestureViewColor)

   }
    
    private func setupUI() {
        self.view.backgroundColor = .appBlack
        
        self.view.addSubview(self.contentView)
        
        self.contentView.addSubview(self.welcomLabel)
        self.contentView.addSubview(self.infoView)
        
        self.infoView.addSubview(self.picView)
        self.infoView.addSubview(self.nameTextField)
        self.infoView.addSubview(self.latitudeTextField)
        self.infoView.addSubview(self.longitudeTextField)
        self.infoView.addSubview(self.descriptionTextView)
//        self.infoView.addSubview(self.locationView)
//        self.infoView.addSubview(self.notifyOnExitSwitch)
//        self.infoView.addSubview(self.notifyOnEntrySwitch)
//        self.infoView.addSubview(self.notifyOnRepeatSwitch)

        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.createButton)
    }
    
    private func setupConstraints() {
        //in safeAreaLayoutGuide
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(createButton.snp.centerY)
        }
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8.0)
            make.horizontalEdges.equalToSuperview().inset(20.0)
            make.height.equalTo(45.0)
        }
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(cancelButton.snp.top).inset(-8.0)
            make.horizontalEdges.equalToSuperview().inset(20.0)
            make.height.equalTo(45.0)
        }

        //in contentView
        welcomLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20.0)
            make.top.equalToSuperview().inset(20)
        }
        infoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20.0)
            make.top.equalTo(welcomLabel.snp.bottom).inset(-10.0)
            make.bottom.equalTo(descriptionTextView.snp.bottom).inset(-16)
        }
        
        //in infoView
        picView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.top.equalTo(infoView.snp.top).inset(16.0)
            make.height.equalTo(40.0)
        }
        nameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.top.equalTo(picView.snp.bottom).inset(-8.0)
        }
        latitudeTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.top.equalTo(nameTextField.snp.bottom).inset(-8.0)
        }
        longitudeTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.top.equalTo(latitudeTextField.snp.bottom).inset(-8.0)
        }
        descriptionTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.top.equalTo(longitudeTextField.snp.bottom).inset(-16.0)
            make.height.equalTo(150.0)
        }
    }

    @objc private func createDidTap(_ sender: UIButton) { viewModel.createDidTap() }
    
    @objc private func dismissDidTap() { viewModel.dismissDidTap() }

    @objc private func tapGestureDone() { view.endEditing(true) }
    
    @objc private func tapGestureColor() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Выберите цвет метки"
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        colorPicker.selectedColor = self.picView.backgroundColor ?? .gradient1
        self.present(colorPicker, animated: true, completion: nil)
    }

}

extension CreatePlanPointVC: LineTextFieldPotocol { }

extension CreatePlanPointVC: LineTextViewPotocol {
    
    func lineTextViewDidEndEditing(_ lineTextView: LineTextView) {
        if lineTextView == self.descriptionTextView {
            descriptionTextView.setDefaultText()
            viewModel.point?.descr = descriptionTextView.getText()
        }
    }
    
    func lineTextViewDidChangeSelection(_ lineTextView: LineTextView) {
        if lineTextView == self.descriptionTextView {
            viewModel.point?.descr = descriptionTextView.getText()
        }
    }
    
    func lineTextViewDidBeginEditing(_ lineTextView: LineTextView) {
        if lineTextView == self.descriptionTextView {
            descriptionTextView.setEditingText()
        }
    }
    
    func lineTextView(_ lineTextView: LineTextView,
                      shouldChangeTextIn range: NSRange,
                      replacementText text: String
    ) -> Bool {
        return true
    }

}


extension CreatePlanPointVC: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.picView.backgroundColor = viewController.selectedColor
        viewModel.point?.color = viewController.selectedColor.rgbToHex()
    }
    
//    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
//        self.picView.backgroundColor = viewController.selectedColor
//    }

}
