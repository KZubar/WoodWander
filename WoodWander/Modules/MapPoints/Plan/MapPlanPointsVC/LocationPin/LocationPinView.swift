//
//  LocationPinView.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

import MapKit
import SnapKit


final class LocationPinView: MKAnnotationView {
    
    private var param: LocationPinParameters = .big
    
    private lazy var pointView: CircleView = CircleView()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.10) {
                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
            } else {
                UIView.animate(withDuration: 0.10) {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(pointView)
        
        setupFrame()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//    //FIXME: - DELETE - раз ничего нет внутри, то и не нужен код
//    override var annotation: MKAnnotation? {
//       didSet {
//            guard let customAnnotation = annotation as? LocationPin else { return }
//        }
//    }

    func setupIcon() {
        if let marker = annotation as? LocationPin {
            self.param = marker.param
            
            pointView.frame = .init(origin: .zero, size: param.sizeRenderer)
            
            
            pointView.cornerRadius = param.sizeRenderer.width / 2
            pointView.cornerRadiusIn = (param.sizeRenderer.width-2*param.edgeOffset) / 2
            pointView.cornerRadiusImg = (param.sizeRenderer.width-2*param.edgeOffset) / 2
            
            var colorPin: UIColor
            if marker.isTapPin {
                colorPin = .gradient0
            } else {
                colorPin = .appBlue
                if let hex = marker.color {
                    if !hex.isEmpty {
                        colorPin = UIColor.hexToRGB(hexStr: hex)
                    }
                }
            }
            
            pointView.tintColorImg = .appWhite
            pointView.backgroundColor = .appWhite
            pointView.backgroundColorIn = colorPin
            pointView.backgroundColorImg = colorPin
            
            pointView.isHiddenIn = !param.isHiddenImg
            pointView.isHiddenImage = param.isHiddenImg
            
            var imagePin: UIImage? = nil
            //pointView.image = .Map.mappin
            if marker.isTapPin {
                imagePin = UIImage(systemName: "star")
            } else {
                if let nameImage = marker.icon {
                    imagePin = UIImage(systemName: nameImage)
                }
            }        
            imagePin = UIImage(named: "avto_001")
            pointView.image = imagePin
            
            setupFrame()
            setupConstraints()
        }
    }
    
    private func setupFrame() {
        self.frame.size = param.sizeRenderer
//        pointView.image = param.image
    }
    
    private func setupConstraints() {
        pointView.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
    }
}
