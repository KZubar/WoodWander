//
//  MainTabBarVC.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

@objc protocol MainTabBarViewModelProtocol { }

final class MainTabBarVC: UITabBarController {    
    
    private var viewModel: MainTabBarViewModelProtocol
    
    init(viewModel: MainTabBarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        
        bild()
    }
    
    private func bild() { }
    
    private func setupUI() {
    }
    
    private func setupConstraints() { }
    
}
