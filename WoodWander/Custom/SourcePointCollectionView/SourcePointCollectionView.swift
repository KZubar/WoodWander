//
//  SourcePointCollectionView.swift
//  WoodWander
//
//  Created by k.zubar on 3.10.24.
//

import UIKit

let testSourceDTO: [String] = ["Viber",
                         "Google maps",
                         "Internet",
                         "Instargamm",
                         "Telegramm",
                         "alex",
                         "грибник.бай",
                         "Грибники РБ",
                         "Лесовичок"]

protocol SourcePointCollectionViewDelegate: AnyObject {
    func sourcePointCollectionView(_ filterView: SourcePointCollectionView,
                                   didSelect type: String)
}

final class SourcePointCollectionView: UIView {
    
    private enum Const {
        static let mininumLineSpacing: CGFloat = 8.0 // отступ между строками
        static let horizontalInsert: CGFloat = 16.0 //отступ слева и справа от первой и посленей ячейки
        static let contentHeight: CGFloat = 32.0 // высота ячейки
        static let mininumItemWidth: CGFloat = 51.0 //минимальная ширина ячейки
        static let titlePadding: CGFloat = 8.0 //отступ слева и справа от title внутри ячейки
        static let minimumInteritemSpacing: CGFloat = 8.0 // отступ между ячейками
    }
    
    private lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Const.mininumLineSpacing
        layout.minimumInteritemSpacing = Const.minimumInteritemSpacing
        layout.sectionInset = UIEdgeInsets(top: .zero,
                                           left: Const.horizontalInsert,
                                           bottom: .zero,
                                           right: Const.horizontalInsert)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        // Скрываем индикаторы прокрутки
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(SourcePointCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()
    
    weak var delegat: SourcePointCollectionViewDelegate?
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear

//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            print("Текущий отступ между ячейками: \(flowLayout.minimumInteritemSpacing)")
//        }

        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
//FIXME: - почему не работает? зачем он тут, если передаем в init frame?
//        self.snp.makeConstraints { make in
//            make.height.equalTo(Const.contentHeight)
//        }

//        self.snp.makeConstraints { make in
//            make.height.equalTo(32.0)
//        }

        collectionView.selectItem(at: .init(row: .zero, section: .zero),
                                  animated: false,
                                  scrollPosition: .left)
    }
}


extension SourcePointCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        return testSourceDTO.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SourcePointCollectionCell = collectionView.dequeue(at: indexPath)
        cell.setup(with: testSourceDTO[indexPath.row])
        return cell
    }
    
}

extension SourcePointCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        delegat?.sourcePointCollectionView(
            self,
            didSelect: testSourceDTO[indexPath.row]
        )
    }
}

extension SourcePointCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        //наша строка
        let title: String = testSourceDTO[indexPath.row]
        
        //определяем сколько места занимает title
        let calculatedWidth = title.minimumWidthToDisplay(
            font: .appFont.withSize(12.0),
            height: Const.contentHeight
        ) + Const.titlePadding * 2
        
        let width = calculatedWidth < Const.mininumItemWidth
                    ? Const.mininumItemWidth
                    : calculatedWidth
        
        return CGSize(width: width, height: Const.contentHeight)
    }
}
