//
//  ChooseCategoriesPointVC.swift
//  WoodWander
//
//  Created by k.zubar on 27.08.24.
//

import UIKit

final class ChooseCategoriesPointVC: UIViewController {

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        return view
    }()
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        return view
    }()

    private lazy var welcomLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавление в список"
        label.font = .appBoldFont.withSize(18.0)
        label.textColor = .mainFont
        label.textAlignment = .center
        return label
    }()
    
    private lazy var newCategoriesButton: UIButton = .bigButton(
        title: "   Новый список",
        image: UIImage.init(icon: UIImage.All.plus,
                            size: CGSize(width: 12, height: 12),
                            textColor: .appBlue)
    ).withAction(self, #selector(newCategoriesDidTap), for: .touchUpInside)
    
    private lazy var saveButton: UIButton = .bigButton(
        title: "Готово",
        image: nil,
        titleColor: .appWhite,
        backgroundColor: .appBlue
    ).withAction(self, #selector(saveDidTap), for: .touchUpInside)

    private lazy var cancelButton: UIButton = {
        let bttn = UIButton()
        bttn.setIcon(
            icon: UIImage.Categories.closeRound,
            iconSize: 20,
            color: .appBlack,
            forState: .normal)
        return bttn
    }().withAction(self,
                   #selector(cancelDidTap),
                   for: .touchUpInside)


    
    
    
    private lazy var tableView: UITableView = viewModel.makeTableView()

    private var viewModel: ChooseCategoriesPointViewModelProtocol
    
    init(viewModel: ChooseCategoriesPointViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()

        setupUI()
        setupConstraints()
        bind()
     }
        
    
    
    private func bind() { }

    private func setupUI() {
        view.backgroundColor = .appWhite //FIXME: - другой цвет
        
        view.addSubview(contentView)
        
        contentView.addSubview(welcomLabel)
        contentView.addSubview(cancelButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(newCategoriesButton)
        contentView.addSubview(infoView)

        infoView.addSubview(tableView)
    }

    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
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
        newCategoriesButton.snp.makeConstraints { make in
            make.top.equalTo(welcomLabel.snp.bottom).inset(-16.0)
            make.horizontalEdges.equalToSuperview().inset(32.0)
            make.height.equalTo(40.0)
        }
        infoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(newCategoriesButton.snp.bottom).inset(-8.0)
            make.bottom.equalTo(saveButton.snp.top).inset(-8.0)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8.0)
            make.height.equalTo(40.0)
            make.horizontalEdges.equalToSuperview().inset(32.0)
        }
        
        //in infoView
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

    }

}


extension ChooseCategoriesPointVC {
    
    @objc func newCategoriesDidTap(sender: UIView) {
        viewModel.openEditCategoriesPoint()
    }
    
    @objc func cancelDidTap(sender: UIView) {
        viewModel.dismissDidTap()
    }
    
    @objc func saveDidTap(sender: UIView) {
        viewModel.saveDidTap()
    }
}

