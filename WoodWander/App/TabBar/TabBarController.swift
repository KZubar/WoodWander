//
//  TabBarController.swift
//  WoodWander
//
//  Created by k.zubar on 28.06.24.
//

import UIKit

struct TabBarModule {
    let coordinator: UIViewController //FIXME: - тут был этот тип Coordinator
    let button: TabBarButton
    let delegate: AppCoordinatorDelegate
}

class TabBarController: UITabBarController {
    private enum Layout {
        static var height: CGFloat = 49.0
    }
    
    private let buttonItems: [TabBarButton]
    private var customTabBar: TabBar!
    private var constraintsAreActive = false
    
    init(modules: [TabBarModule]) {
        self.buttonItems = modules.map { $0.button }
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = modules.map {
            let vc = $0.coordinator
            //FIXME: - закомментировал, потом разберусь vc.delegate = $0.delegate
            vc.additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: Layout.height, right: 0)
            return vc
        }
        tabBar.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        setupTabBar(with: buttonItems)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard !constraintsAreActive else { return }
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBar.heightAnchor.constraint(equalToConstant: Layout.height),
            customTabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])

        constraintsAreActive = true
    }

    private func setupTabBar(with items: [TabBarButton]) {
        customTabBar = TabBar(buttonItems: items)
        view.addSubview(customTabBar)
        
        for i in 0 ..< items.count {
            items[i].tag = i
            items[i].addTarget(self, action: #selector(switchTab(sender:)), for: .touchUpInside)
        }
        //FIXME: - зачем скрыты крайние модули
        //hideUnusedModules()
    }
    
    @objc func switchTab(sender: TabBarButton) {
        selectTab(index: sender.tag)
    }

    func selectTab(index: Int) {
        selectedIndex = index
        buttonItems.forEach { tabBarButton in
            tabBarButton.isSelected = (tabBarButton.tag == selectedIndex)
        }
    }
}

//extension TabBarController {
//    private func hideUnusedModules() {
//        buttonItems.first?.isHidden = true
//        buttonItems.last?.isHidden = true
//    }
//}
