//
//  MainTabBarVC.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

@objc protocol MainTabBarViewModelProtocol {
    @objc func addButtonDidTap(sender: UIView)
}

final class MainTabBarVC: UITabBarController {
    
    //объявим два опциональных свойства для хранения рисуемых CALayer:
    private var circleLayer: CALayer?
    
    private enum Const {
        //объявим вычисляемые свойства для работы с таб-баром, а также константу для радиуса полукруга обводки
        static let circleRadius: CGFloat = 29
        static let shiftingShape: CGFloat = 0

        //диаметр средней кнопки (по дизайну он равен 50),
        static let middleButtonDiameter: CGFloat = 50
    }
    //объявим вычисляемые свойства для работы с таб-баром, а также константу для радиуса полукруга обводки
    private var centerWidth: CGFloat { self.tabBar.bounds.width / 2 }
    
    
    //кнопка в центре TabBar
    private lazy var middleButton: UIButton = {
        let bttn = UIButton()
        bttn.layer.cornerRadius = Const.middleButtonDiameter / 2
        bttn.addTarget(viewModel,
                       action: #selector(MainTabBarViewModelProtocol.addButtonDidTap(sender:)),
                       for: .touchUpInside)
        return bttn
    }()
    
    //для отображения иконки внутри кнопки.
    private lazy var imageMiddleButton: UIImageView = UIImageView(image: .Temp.addAction)
    
    private var viewModel: MainTabBarViewModelProtocol
    
    init(viewModel: MainTabBarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //Объявим метод для вычисления границ обводки таб-бара,
    //  который будет возвращать CGPath – буквально путь,
    //  по которому мы будем двигаться, рисуя обводку полукруга:
    
    private func circlePath() -> CGPath {
        let path = UIBezierPath() // Создаем и инициализируем константу path типа UIBezierPath
        let point = CGPoint(x: centerWidth, y: Const.shiftingShape)
        path.addArc(withCenter: point, // Для отрисовки полукруга используем метод addArc, первым параметром которого является центр полукруга. Это точка в центре таб-бара по оси x и с отступом вниз на shiftingShape пикселей по оси y (по дизайну полукруг выступает над таб-баром на 15 пикселей).
                    radius: Const.circleRadius, // Указываем радиус полукруга.
                    startAngle: 180 * .pi / 180, // Указываем начальный угол.
                    endAngle: 0 * 180 / .pi, // Указываем конечный угол.
                    clockwise: true) // Указываем направление отрисовки полукруга – по часовой стрелке.
        return path.cgPath //Возвращаем путь в виде объекта CGPath
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
        
        //shiftingShape = 12
        //drawTabBar()
        
        setupUI()
        setupConstraints()
    }
    
    private func setTabBar() {
        //FIXME: - set color
        tabBar.tintColor = .yellow //.appYellow
        tabBar.backgroundColor = .black //.appBlack
        tabBar.unselectedItemTintColor = .systemGray3 //.appGray
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithTransparentBackground()

            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private func setupUI() {
        //tabBar.addSubview(middleButton)
        view.addSubview(middleButton)
        middleButton.addSubview(imageMiddleButton)
    }
    
    private func setupConstraints() {
        middleButton.snp.makeConstraints { make in
            make.height.width.equalTo(Const.middleButtonDiameter)
            make.centerX.equalTo(tabBar.snp.centerX)
            make.top.equalTo(tabBar.snp.top).inset(-Const.middleButtonDiameter/2 + Const.shiftingShape)
        }
        imageMiddleButton.snp.makeConstraints { make in
            make.centerX.equalTo(middleButton.snp.centerX)
            make.centerY.equalTo(middleButton.snp.centerY)
        }
    }
    
}

extension MainTabBarVC: UITabBarControllerDelegate {
    
    //обводка вокруг центральной кнопки
    fileprivate func drawTabBar() {
        // 1 Объявляем константу circleLayer типа CAShapeLayer для создания слоя обводки полукруга таб-бара. У нее указываем путь, цвет обводки, цвет заливки и ширину линии.
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath()
        //FIXME: - set color
        circleLayer.strokeColor = UIColor.systemGray3.cgColor //UIColor.appGray.cgColor
        circleLayer.fillColor = UIColor.black.cgColor //UIColor.appBlack.cgColor
        circleLayer.lineWidth = 1.0
        
        // 3 Проверяем, были ли данные слои добавлены ранее. Если да, подменяем их только что созданными, если нет – добавляем созданные слои, используя метод insertSublayer.
        if let oldCircleLayer = self.circleLayer {
            self.tabBar.layer.replaceSublayer(oldCircleLayer, with: circleLayer)
        } else {
            self.tabBar.layer.insertSublayer(circleLayer, at: 1)
        }
        
        // 4 Сохраняем созданные слои в соответствующие свойства класса.
        self.circleLayer = circleLayer
    }
    
}
