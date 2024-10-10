//
//  ChooseCategoriesPointVC_copy2.swift
//  WoodWander
//
//  Created by k.zubar on 4.10.24.
//


//import UIKit
//
//final class ChooseCategoriesPointVC: UIViewController {
//
//    private enum Const {
//        static let tableSourceViewHeight: Double = 30.0
//        static let tableForestViewHeight: Double = 30.0
//    }
//
//    //весь контент разместим внутри ее
//    private lazy var contentView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .appWhite
//        return view
//    }()
//    
//    //панель. Их будет две. Это первая - тут будут списки
//    private lazy var panelCategoryView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .appWhite
//        return view
//    }()
//    
//    //панель. Их будет две. Это вторая - тут будет дополнительная информация по для точки
//    private lazy var panelInfoView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .appWhite
//        return view
//    }()
//
////    private lazy var infoView: UIView = {
////        let view = UIView()
////        view.backgroundColor = .appWhite
////        return view
////    }()
//
//    private lazy var welcomLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Описание метки"
//        label.font = .appBoldFont.withSize(18.0)
//        label.textColor = .mainFont
//        label.textAlignment = .center
//        return label
//    }()
//    
//    private lazy var panelCategoriesActiveButton: UIButton = .bigButton(
//        title: "Добавить в списки"
//    ).withAction(self, #selector(panelCategoriesActiveButtonDidTap), for: .touchUpInside)
//    
//    private lazy var panelInfoActiveButton: UIButton = .bigButton(
//        title: "Добавить информацию"
//    ).withAction(self, #selector(panelInfoActiveButtonDidTap), for: .touchUpInside)
//
//    private lazy var newCategoriesButton: UIButton = .bigButton(
//        title: "   Новый список",
//        image: UIImage.init(icon: UIImage.All.plus,
//                            size: CGSize(width: 12, height: 12),
//                            textColor: .appBlue)
//    ).withAction(self, #selector(newCategoriesDidTap), for: .touchUpInside)
//    
//    private lazy var saveButton: UIButton = .bigButton(
//        title: "Готово",
//        image: nil,
//        titleColor: .appWhite,
//        backgroundColor: .appBlue
//    ).withAction(self, #selector(saveDidTap), for: .touchUpInside)
//    
//    private lazy var cancelButton: UIButton = {
//        let bttn = UIButton()
//        bttn.setIcon(
//            icon: UIImage.Categories.closeRound,
//            iconSize: 20,
//            color: .appBlack,
//            forState: .normal)
//        return bttn
//    }().withAction(self,
//                   #selector(cancelDidTap),
//                   for: .touchUpInside)
//
//
//    
//    
//
//    private lazy var contentSourcePointView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .appBlue.withAlphaComponent(0.05)//.clear//.red.withAlphaComponent(0.5)
//        return view
//    }()
//    private lazy var sourcePointTitle: UILabel = {
//        let label = UILabel()
//        label.text = "Источник информации:"
//        label.font = .appBoldFont.withSize(14.0)
//        label.textColor = .mainFont
//        label.textAlignment = .left
//        //label.backgroundColor = .appYellow.withAlphaComponent(0.5)
//        return label
//    }()
//    private lazy var tableSourcePointView: SourcePointCollectionView = {
//        let frame = CGRect(x: .zero,
//                           y: .zero,
//                           width: .zero,
//                           height: Const.tableSourceViewHeight)
//        let headerView = SourcePointCollectionView(frame: frame)
//        //headerView.backgroundColor = .appBlue.withAlphaComponent(0.05)
//        headerView.delegat = self
//        return headerView
//    }()
//
//    private lazy var contentForestPointView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .appGreen.withAlphaComponent(0.05)//.clear//.red.withAlphaComponent(0.5)
//        return view
//    }()
//    private lazy var forestPointTitle: UILabel = {
//        let label = UILabel()
//        label.text = "Об этом месте:"
//        label.font = .appBoldFont.withSize(14.0)
//        label.textColor = .mainFont
//        label.textAlignment = .left
//        //label.backgroundColor = .appYellow.withAlphaComponent(0.5)
//        return label
//    }()
//    private lazy var tableForestPointView: ForestPointCollectionView = {
//        let frame = CGRect(x: .zero,
//                           y: .zero,
//                           width: .zero,
//                           height: Const.tableForestViewHeight)
//        let headerView = ForestPointCollectionView(frame: frame)
//        //headerView.backgroundColor = .appGreen.withAlphaComponent(0.05)
//        headerView.delegat = self
//        return headerView
//    }()
//
//    private lazy var tableView: UITableView = viewModel.makeTableView()
//
//    private var viewModel: ChooseCategoriesPointViewModelProtocol
//    
//    init(viewModel: ChooseCategoriesPointViewModelProtocol) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        viewModel.viewDidLoad()
//
//        setupUI()
//        setupConstraints()
//        bind()
//     }
//        
//    
//    
//    private func bind() { }
//
//    private func setupUI() {
//        view.backgroundColor = .appWhite
//        
//        self.panelCategoryView.isHidden = false
//        self.panelInfoView.isHidden = true
//        self.panelCategoriesActiveButton.backgroundColor = .appBlueLight
//        self.panelInfoActiveButton.backgroundColor = .appWhite
//        
//        view.addSubview(contentView)
//        
//        contentView.addSubview(welcomLabel)
//        contentView.addSubview(cancelButton)
//        contentView.addSubview(saveButton)
//        contentView.addSubview(panelCategoriesActiveButton)
//        contentView.addSubview(panelInfoActiveButton)
//
//        contentView.addSubview(panelCategoryView)
//            panelCategoryView.addSubview(newCategoriesButton)
//            panelCategoryView.addSubview(tableView)
//
//        
//        contentView.addSubview(panelInfoView)
//            panelInfoView.addSubview(contentSourcePointView)
//            panelInfoView.addSubview(contentForestPointView)
//                contentSourcePointView.addSubview(tableSourcePointView)
//                contentForestPointView.addSubview(tableForestPointView)
//                contentSourcePointView.addSubview(sourcePointTitle)
//                contentForestPointView.addSubview(forestPointTitle)
//    }
//
//    private func setupConstraints() {
//        //contentView
//        contentView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
//        }
//        
//        //in contentView
//        welcomLabel.snp.makeConstraints { make in
//            make.centerX.equalTo(contentView.snp.centerX)
//            make.top.equalToSuperview().inset(8)
//        }
//        cancelButton.snp.makeConstraints { make in
//            make.centerY.equalTo(welcomLabel.snp.centerY)
//            make.left.equalToSuperview().inset(16)
//        }
//        saveButton.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8.0)
//            make.height.equalTo(40.0)
//            make.horizontalEdges.equalToSuperview().inset(32.0)
//        }
//        panelCategoriesActiveButton.snp.makeConstraints { make in
//            make.top.equalTo(welcomLabel.snp.bottom).inset(-16.0)
//            make.left.equalToSuperview().inset(16.0)
//            make.height.equalTo(40.0)
//        }
//        panelInfoActiveButton.snp.makeConstraints { make in
//            make.top.equalTo(welcomLabel.snp.bottom).inset(-16.0)
//            make.left.equalTo(panelCategoriesActiveButton.snp.right).inset(-16.0)
//            make.right.equalToSuperview().inset(16.0)
//            make.height.equalTo(40.0)
//        }
//
//
//        //panelCategoryView
//        panelCategoryView.snp.makeConstraints { make in
//            make.top.equalTo(panelCategoriesActiveButton.snp.bottom).inset(-16.0)
//            make.horizontalEdges.equalToSuperview()
//            make.bottom.equalTo(saveButton.snp.top).inset(-8.0)
//        }
//        //in panelCategoryView
//        newCategoriesButton.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.horizontalEdges.equalToSuperview().inset(32.0)
//            make.height.equalTo(40.0)
//        }
//        tableView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.top.equalTo(newCategoriesButton.snp.bottom).inset(-8.0)
//            make.bottom.equalToSuperview()
//        }
//
//        
//        
//        //panelInfoView
//        panelInfoView.snp.makeConstraints { make in
//            make.top.equalTo(panelCategoriesActiveButton.snp.bottom).inset(-16.0)
//            make.horizontalEdges.equalToSuperview()
//            make.bottom.equalTo(saveButton.snp.top).inset(-8.0)
//        }
//        //in panelInfoView
//        contentSourcePointView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.horizontalEdges.equalToSuperview()//.inset(8.0)
//        }
//        contentForestPointView.snp.makeConstraints { make in
//            make.top.equalTo(contentSourcePointView.snp.bottom).inset(-16.0)
//            make.horizontalEdges.equalToSuperview()//.inset(8.0)
//        }
//
//        
//        //in contentSourcePointView
//         sourcePointTitle.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(8.0)
//            make.height.equalTo(16)
//            make.horizontalEdges.equalToSuperview().inset(16.0)
//        }
//        tableSourcePointView.snp.makeConstraints { make in
//            make.top.equalTo(sourcePointTitle.snp.bottom)//.inset(-8.0)
//            make.horizontalEdges.equalToSuperview()//.inset(8.0)
//            make.height.equalTo(Const.tableForestViewHeight+20)
//            make.bottom.equalToSuperview()
//        }
//
//        //in contentForestPointView
//        forestPointTitle.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(8.0)
//            make.height.equalTo(16)
//            make.horizontalEdges.equalToSuperview().inset(16.0)
//        }
//        tableForestPointView.snp.makeConstraints { make in
//            make.top.equalTo(forestPointTitle.snp.bottom)//.inset(-8.0)
//            make.horizontalEdges.equalToSuperview()//.inset(8.0)
//            make.height.equalTo(Const.tableForestViewHeight+20)
//            make.bottom.equalToSuperview()
//        }
//
//        
//        
//        
//        
//
//    }
//
//}
//
//
//extension ChooseCategoriesPointVC {
//    
//    @objc func newCategoriesDidTap(sender: UIView) {
//        viewModel.openEditCategoriesPoint()
//    }
//    
//    @objc func cancelDidTap(sender: UIView) {
//        viewModel.dismissDidTap()
//    }
//    
//    @objc func saveDidTap(sender: UIView) {
//        viewModel.saveDidTap()
//    }
//    
//    @objc func panelCategoriesActiveButtonDidTap(sender: UIView) {
//        self.panelCategoryView.isHidden = false
//        self.panelInfoView.isHidden = true
//        self.panelCategoriesActiveButton.backgroundColor = .appBlueLight
//        self.panelInfoActiveButton.backgroundColor = .appWhite
//    }
//    
//    @objc func panelInfoActiveButtonDidTap(sender: UIView) {
//        self.panelCategoryView.isHidden = true
//        self.panelInfoView.isHidden = false
//        self.panelCategoriesActiveButton.backgroundColor = .appWhite
//        self.panelInfoActiveButton.backgroundColor = .appBlueLight
//    }
//}
//
//extension ChooseCategoriesPointVC: SourcePointCollectionViewDelegate {
//    func sourcePointCollectionView(_ filterView: SourcePointCollectionView,
//                                didSelect type: String
//    ) {
//        //filterDidSelect?(type)
//     }
//}
//
//extension ChooseCategoriesPointVC: ForestPointCollectionViewDelegate {
//    func forestPointCollectionView(_ filterView: ForestPointCollectionView,
//                                   didSelect type: String
//    ) {
//        //filterDidSelect?(type)
//     }
//}
//
