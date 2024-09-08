//
//  CategoriesPointVC.swift
//  WoodWander
//
//  Created by k.zubar on 21.08.24.
//

import UIKit

final class CategoriesPointVC: UIViewController {

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        return view
    }()
    
    private lazy var welcomLabel: UILabel = {
        let label = UILabel()
        label.text = "Сохранено"
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
    
    
    
    
    
    
    private lazy var tableView: UITableView = viewModel.makeTableView()
    
    private var viewModel: CategoriesPointViewModelProtocol
    
    init(viewModel: CategoriesPointViewModelProtocol) {
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
        contentView.addSubview(newCategoriesButton)
        contentView.addSubview(tableView)
    }
    
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        welcomLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8.0)
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalTo(contentView.snp.centerX)
        }
        newCategoriesButton.snp.makeConstraints { make in
            make.top.equalTo(welcomLabel.snp.bottom).inset(-16.0)
            make.horizontalEdges.equalToSuperview().inset(32.0)
            make.height.equalTo(40.0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(newCategoriesButton.snp.bottom).inset(-8.0)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }
}


extension CategoriesPointVC {
    @objc func newCategoriesDidTap(sender: UIView) {
        viewModel.openEditCategoriesPoint()
    }
    
}

