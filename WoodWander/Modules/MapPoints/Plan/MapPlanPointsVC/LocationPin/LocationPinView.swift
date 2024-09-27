//
//  LocationPinView.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

import MapKit
import SnapKit


final class LocationPinView: MKAnnotationView {
    
    private enum Color {
        static let defaultByMarker: UIColor = .defaultByMarker
    }

    private var param: LocationPinParameters = .big
    
    private var dto: PlanPointDescription?
    
    private lazy var pointView: CircleView = CircleView()

    override var isSelected: Bool {
        didSet {
            let scale: CGFloat = isSelected ? 1.5 : 1.0
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
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
            //self.param = .big

            pointView.frame = .init(origin: .zero, size: param.sizeRenderer)
            
            
            pointView.cornerRadius = param.sizeRenderer.width / 2
            pointView.cornerRadiusIn = (param.sizeRenderer.width-2*param.edgeOffset) / 2
            pointView.cornerRadiusImg = (param.sizeRenderer.width-2*param.edgeOffset) / 2
            
            var colorPin: UIColor?
            if marker.isTapPin {
                colorPin = .gradient0
            } else {
                colorPin = Color.defaultByMarker
                if let hex = marker.color {
                    if !hex.isEmpty {
                        colorPin = UIColor.hexToRGB(hexStr: hex)
                    }
                }
            }
            
            //pointView.tintColorImg = .clear
            pointView.backgroundColor = .appWhite
            pointView.backgroundColorIn = .appWhite
            pointView.backgroundColorImg = colorPin
            
            if self.param == .big {
                if let icon = marker.icon {
                    if !icon.isEmpty {
                        pointView.backgroundColorImg = .clear
                        pointView.backgroundColorIn = colorPin
                    }
               }
            } else {
                pointView.backgroundColorIn = colorPin
            }


//            if let icon = marker.icon {
//                pointView.backgroundColorImg = icon.isEmpty ? colorPin : .clear
//            } else {
//                pointView.backgroundColorImg = self.param == .big ? .clear : colorPin
//            }
                
            
            pointView.isHiddenIn = !param.isHiddenImg
            pointView.isHiddenImage = param.isHiddenImg
            
            pointView.contentModeImg = .scaleToFill
            
//            var imagePin: UIImage?
            //pointView.image = .Map.mappin
//            if marker.isTapPin {
//                imagePin = UIImage(systemName: "star")
//            } else {
//                if let nameImage = marker.icon {
//                    if !nameImage.isEmpty {
//                        imagePin = UIImage(
//                    }
//                }
//            }        
//            imagePin = UIImage(icon: .googleMaterialDesign(.formatListBulleted),
//                               size: CGSize(width: 20.0, height: 20.0))
            
            
//            pointView.image = imagePin
            
            if self.param == .big {
                pointView.icon = marker.icon ?? ""
            }
            
            
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
