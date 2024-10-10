
import UIKit
import SnapKit

class MyVC: UIViewController {
    
    private enum ConstSize {
        static let viewHeight: Double = 45.0
        static let buttonHeight: Double = 35.0
        static let buttonCloseWidth: Double = 70.0
        static let distanceBetween: Double = 5.0
    }
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite.withAlphaComponent(0.25)
        view.layer.cornerRadius = ConstSize.viewHeight / 2
        view.setBorder(width: 1, color: .appBlue)
        return view
    }()
    
    //растягивает
    private lazy var resizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.backgroundColor = .appWhite.withAlphaComponent(0.25)
        button.setBorder(width: 1, color: .appRed)
        button.layer.cornerRadius = ConstSize.buttonHeight / 2
        return button
    }().withAction(self, #selector(resizeButtonDidTap), for: .touchUpInside)
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите текст"
        //textField.setBorder(width: 1, color: .appBlack)
        return textField
    }()
    
    //сужает
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Закрыть", for: .normal)
        button.layer.cornerRadius = ConstSize.buttonHeight / 2
        button.backgroundColor = .appWhite.withAlphaComponent(0.25)
        //button.setBorder(width: 1, color: .appGreen)
       return button
    }().withAction(self, #selector(collapseView), for: .touchUpInside)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .appWhite
        
        //при открытии скрываем
        self.closeButton.alpha = 0.0
        self.textField.alpha = 0.0
        
        self.view.addSubview(searchView)
        self.searchView.addSubview(resizeButton)
        self.searchView.addSubview(textField)
        self.searchView.addSubview(closeButton)
        
        // Установка констрейтов с использованием SnapKit
        searchView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(ConstSize.viewHeight)
            make.width.equalTo(ConstSize.viewHeight)
        }
        
        resizeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(ConstSize.distanceBetween)
            make.centerY.equalToSuperview()
            make.width.equalTo(ConstSize.buttonHeight)
            make.height.equalTo(ConstSize.buttonHeight)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(ConstSize.buttonHeight)
            make.horizontalEdges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(ConstSize.buttonHeight)
            make.horizontalEdges.equalToSuperview()
        }
    }

    @objc func resizeButtonDidTap() {
        
        self.resizeButton.isUserInteractionEnabled = false
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            
            // Первая анимация: расширение searchView, меняем closeButton Constraints
            UIView.addKeyframe(withRelativeStartTime: 0.00, relativeDuration: 0.25) {
                self.searchView.snp.remakeConstraints { make in
                    make.right.equalToSuperview().inset(15)
                    make.top.equalToSuperview().inset(100)
                    make.height.equalTo(ConstSize.viewHeight)
                    make.width.equalTo(ConstSize.viewHeight + ConstSize.distanceBetween + ConstSize.buttonCloseWidth)
                }
                self.closeButton.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.height.equalTo(ConstSize.buttonHeight)
                    make.width.equalTo(ConstSize.buttonCloseWidth)
                    make.right.equalToSuperview().inset(ConstSize.distanceBetween)
                }
                self.view.layoutIfNeeded()
            }
            
            // третья анимация: показываем closeButton, раздвигаем searchView и меняем textField Constraints
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.15) {
                self.closeButton.alpha = 1.0
                self.searchView.snp.remakeConstraints { make in
                    make.right.equalToSuperview().inset(15)
                    make.top.equalToSuperview().inset(100)
                    make.height.equalTo(ConstSize.viewHeight)
                    make.width.equalTo(ConstSize.viewHeight*2 + ConstSize.distanceBetween*2 + ConstSize.buttonCloseWidth)
                }
                self.textField.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.height.equalTo(ConstSize.buttonHeight)
                    make.left.equalTo(self.resizeButton.snp.right).offset(ConstSize.distanceBetween)
                    make.right.equalTo(self.closeButton.snp.left).offset(-ConstSize.distanceBetween)
                }
                self.view.layoutIfNeeded()
            }
            
            // последняя анимация: показываем textField и расширяем до конца searchView
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.60) {
                self.textField.alpha = 1.0
                self.searchView.snp.remakeConstraints { make in
                    make.right.equalToSuperview().inset(15)
                    make.top.equalToSuperview().inset(100)
                    make.height.equalTo(ConstSize.viewHeight)
                    make.width.equalTo(self.view.frame.width - 30)
                }
                self.view.layoutIfNeeded()
            }
        }, completion: nil)
    }
    
    @objc func collapseView() {
        
        self.resizeButton.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.25) {
            self.textField.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(ConstSize.buttonHeight)
                make.horizontalEdges.equalToSuperview()
            }
            self.closeButton.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(ConstSize.buttonHeight)
                make.horizontalEdges.equalToSuperview()
            }
            self.searchView.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(15)
                make.top.equalToSuperview().inset(100)
                make.height.equalTo(ConstSize.viewHeight)
                make.width.equalTo(ConstSize.viewHeight)
            }
            self.view.layoutIfNeeded()
            self.closeButton.alpha = 0.0
            self.textField.alpha = 0.0
        }
    }
}
