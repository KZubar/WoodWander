//
//  NewPlaceDescriptionView.swift
//  WoodWander
//
//  Created by k.zubar on 30.06.24.
//

//FIXME: - Перевести параметры на Стиль

import UIKit
import MapKit
import SnapKit

protocol NewPlaceDescriptionViewPotocol: AnyObject {
    func removeLastPointAnnotation()
    func openCreatePlanPontVC()
    func openCategoriesPointVC()
    func openIconViewVC()
}

final class NewPlaceDescriptionView: UIView {
    
    typealias geoCoord = (latitude: Double, longitude: Double)
    
    // MARK: - private
    private var locationCoord: CLLocationCoordinate2D?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Об этом месте"
        label.font = UIFont.appBoldFont.withSize(22.0)
        label.textColor = .mainFont
        label.textAlignment = .left
        return label
    }()
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Расстояние:"
        label.font = UIFont.appBoldFont.withSize(11.0)
        label.textColor = .tetrialyFont
        label.textAlignment = .left
        return label
    }()
    private lazy var distanceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00000, 0.00000"
        label.font = UIFont.appBoldFont.withSize(11.0)
        label.textColor = .tetrialyFont
        label.textAlignment = .left
        return label
    }()
    private lazy var geoLabel: UILabel = {
        let label = UILabel()
        label.text = "Координаты:"
        label.font = UIFont.appBoldFont.withSize(11.0)
        label.textColor = .tetrialyFont
        label.textAlignment = .left
        return label
    }()
    private lazy var geoValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0 m."
        label.font = UIFont.appBoldFont.withSize(11.0)
        label.textColor = .tetrialyFont
        label.textAlignment = .left
        return label
    }()

    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let bttn = UIButton()
        bttn.tintColor = .mainFont
        bttn.setImage(.Menu.xmark, for: .normal)
        bttn.addTarget(self,
                       action: #selector(closeButtonDidTap),
                       for: .touchUpInside)
        return bttn
    }()
    
    private lazy var createWithCategoryButton: NewPlaceDescriptionButtonView = {
        let view = NewPlaceDescriptionButtonView()
        view.backgroundColor = .appWhite
        view.cornerRadius = 5.0
        view.delegat = self
        view.image = UIImage(systemName: "doc.badge.plus")
        view.title = "Добавить в список"
        return view
    }()
    
    private lazy var createButton: NewPlaceDescriptionButtonView = {
        let view = NewPlaceDescriptionButtonView()
        view.backgroundColor = .appWhite
        view.cornerRadius = 5.0
        view.delegat = self
        view.image = UIImage(systemName: "mappin.and.ellipse")
        view.title = "Добавить новое место"
        return view
    }()
    
    private lazy var rainsHistoryButton: NewPlaceDescriptionButtonView = {
        let view = NewPlaceDescriptionButtonView()
        view.backgroundColor = .appWhite
        view.cornerRadius = 5.0
        view.delegat = self
        view.image = UIImage(systemName: "cloud.moon.rain")
        view.title = "Количество осадков"
        return view
    }()
    
    private lazy var forecastButton: NewPlaceDescriptionButtonView = {
        let view = NewPlaceDescriptionButtonView()
        view.backgroundColor = .appWhite
        view.cornerRadius = 5.0
        view.delegat = self
        view.image = UIImage(systemName: "warninglight")
        view.title = "Прогноз"
        return view
    }()

    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.cornerRadius = 5
        view.backgroundColor = .appWhite
        return view
    }()
    
    private lazy var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        return view
    }()
    
    
    // MARK: - public
    func setInfo(
        point locationCoordinate: CLLocationCoordinate2D,
        distance: Double
    ) {
        
        distanceValueLabel.text = Converter.getDistanceMeterToKm(
            distance: distance.roundToNearestValue(0)
        )
        geoValueLabel.text = locationCoordinate.stringLocationCoordinate2D(count: 8)
    }
    
    
    //let number = 1234567.89
    func separatedNumber(_ number: Any) -> String {
        guard
            let itIsANumber = number as? NSNumber
        else { return "Not a number" }
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        
        return formatter.string(from: itIsANumber) ?? ""
    }
    
    //testLabel.text = separatedNumber(number) // выводит "1 234 567,89"
    
    
    // MARK: - delegat
    
    weak var delegat: NewPlaceDescriptionViewPotocol?
    
    
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
        bind()
        setupUI()
        setupConstraints()
    }
    
    private func bind() { }
    
    private func setupUI() {
        
        self.cornerRadius                       = 10
        self.backgroundColor                    = .appWhite
        
        self.descriptionView.backgroundColor    = .appWhite
        self.buttonView.backgroundColor         = .appWhite
        self.closeButton.backgroundColor        = .appWhite

        descriptionView.addSubview(titleLabel)
        descriptionView.addSubview(closeButton)
        descriptionView.addSubview(distanceLabel)
        descriptionView.addSubview(distanceValueLabel)
        descriptionView.addSubview(geoLabel)
        descriptionView.addSubview(geoValueLabel)

        buttonView.addSubview(createButton)
        buttonView.addSubview(createWithCategoryButton)
        buttonView.addSubview(rainsHistoryButton)
        buttonView.addSubview(forecastButton)

        self.addSubview(descriptionView)
        self.addSubview(separator)
        self.addSubview(buttonView)
        
    }
    
    private func setupConstraints() {
        //Line 1.1
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(closeButton.snp.left).inset(-4)
            make.top.equalToSuperview()
        }
        closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(24)
        }
        
        //Line 1.2
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.left.equalToSuperview()
            make.width.equalTo(80)
        }
        distanceValueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.left.equalTo(distanceLabel.snp.right).inset(-4)
            make.right.equalToSuperview()
        }
        
        //Line 1.3
        geoLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).inset(-4)
            make.left.equalToSuperview()
            make.width.equalTo(80)
        }
        geoValueLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).inset(-4)
            make.left.equalTo(geoLabel.snp.right).inset(-4)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
//        createWithCategoryButton.backgroundColor = .blue.withAlphaComponent(0.85)
//        createButton.backgroundColor = .red.withAlphaComponent(0.85)
//        rainsHistoryButton.backgroundColor = .gray.withAlphaComponent(0.85)

        //Line 3.1
        createWithCategoryButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(80)
            make.verticalEdges.equalToSuperview()
        }
        //Line 3.2
        createButton.snp.makeConstraints { make in
            make.left.equalTo(createWithCategoryButton.snp.right).inset(-8.0)
            make.width.equalTo(80)
            make.verticalEdges.equalToSuperview()
        }
        //Line 3.3
        rainsHistoryButton.snp.makeConstraints { make in
            make.left.equalTo(createButton.snp.right).inset(-8.0)
            make.width.equalTo(80)
            make.verticalEdges.equalToSuperview()
        }
        //Line 3.4
        forecastButton.snp.makeConstraints { make in
            make.left.equalTo(rainsHistoryButton.snp.right).inset(-8.0)
            make.width.equalTo(80)
            make.verticalEdges.equalToSuperview()
        }

        //Line 1.0
        descriptionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(8)
        }
        //Line 2.0
        separator.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).inset(-4)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(1)
        }
        //Line 3.0        
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).inset(-4)
            make.horizontalEdges.equalToSuperview().inset(12.0)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    @objc private func closeButtonDidTap(_ sender: UIButton) {
        delegat?.removeLastPointAnnotation()
    }

}

extension NewPlaceDescriptionView: NewPlaceDescriptionButtonViewPotocol {
    func buttonDidTap(_ view: NewPlaceDescriptionButtonView) {
        switch view {
        case self.createButton:
            delegat?.openCreatePlanPontVC()
            return
       case self.createWithCategoryButton:
            delegat?.openCategoriesPointVC()
            return
        case self.rainsHistoryButton:
            delegat?.openIconViewVC()
        default:
            return
        }
    }
}
