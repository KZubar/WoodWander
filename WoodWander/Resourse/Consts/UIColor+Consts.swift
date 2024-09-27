//
//  UIColor.swift
//  WoodWander
//
//  Created by k.zubar on 28.06.24.
//

import UIKit

/**
 Colors from app designs: https://app.zeplin.io/project/5cee489f156b3d1dd4de2677/dashboard
 Color converting from hex to UIColor: https://www.uicolor.xyz/#/hex-to-ui
 */

fileprivate enum AppColor {
    
    /// Cells background e.g. MissionCell container background + Navigation bar
    /// Dark theme: dark
    static let darkBackground = #colorLiteral(red: 0.13, green: 0.13, blue: 0.22, alpha: 1.0)
    static let lightBackground = #colorLiteral(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
    
    /// ViewControllers background
    /// Dark theme: almost_black
    static let appDarkBackground = #colorLiteral(red: 0.04, green: 0.06, blue: 0.09, alpha: 1.0)
    static let appLightBackground = #colorLiteral(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)

    /// Tab bar background
    static let darkTabBarBackground = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let lightTabBarBackground = #colorLiteral(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)

    /// Main font color
    /// Dark theme: pale_gray
    static let mainFontDark = #colorLiteral(red: 0.04, green: 0.06, blue: 0.09, alpha: 1.0)
    static let mainFontLight = #colorLiteral(red: 0.98, green: 0.98, blue: 1.00, alpha: 1.0)

    /// Secondary font color
    /// Dark theme: light_periwinkle
    static let secondaryFontDark = #colorLiteral(red: 0.80, green: 0.84, blue: 0.93, alpha: 1.0)

    /// Tetrialy font color
    /// Dark theme: steel
    static let tetrialyFontDark = #colorLiteral(red: 0.49, green: 0.51, blue: 0.58, alpha: 1.0)
    
    static let defaultByMarker = #colorLiteral(red: 0.49, green: 0.51, blue: 0.58, alpha: 1.0)

    static let greenBlue    = #colorLiteral(red: 0, green: 0.8, blue: 0.47, alpha: 1)
    static let butterScotch = #colorLiteral(red: 1.0, green: 0.76, blue: 0.23, alpha: 1.0)
    static let cherry       = #colorLiteral(red: 0.81, green: 0.00, blue: 0.22, alpha: 1.0)
    
    static let black        = #colorLiteral(red: 0.01, green: 0.05, blue: 0.01, alpha: 1.0)
    static let blue         = #colorLiteral(red: 0.27, green: 0.52, blue: 0.96, alpha: 1)
    static let blueLight0    = #colorLiteral(red: 0.70, green: 0.86, blue: 0.99, alpha: 1.0)
    static let blueLight2    = #colorLiteral(red: 0.7, green: 0.9, blue: 0.99, alpha: 1)
    static let blueLight3    = #colorLiteral(red: 0.7, green: 0.95, blue: 0.99, alpha: 1)
    static let blueLight    = #colorLiteral(red: 0.85, green: 0.95, blue: 0.99, alpha: 1)
    static let white        = #colorLiteral(red: 0.98, green: 0.98, blue: 1.00, alpha: 1.0)
}

extension UIColor {
    
    private convenience init(
        _ r: UInt8,
        _ g: UInt8,
        _ b: UInt8,
        _ a: CGFloat
    ) {
        self.init(red: CGFloat(r)/255.0,
                  green: CGFloat(g)/255.0,
                  blue: CGFloat(b)/255.0,
                  alpha: a)
    }
    
    static let gradient0 = #colorLiteral(red: 1.00, green: 0.79, blue: 0.31, alpha: 1.0)
    static let gradient1 = #colorLiteral(red: 1.00, green: 0.58, blue: 0.34, alpha: 1.0)
    static let gradient2 = #colorLiteral(red: 1.00, green: 0.34, blue: 0.49, alpha: 1.0)
    static let gradient3 = #colorLiteral(red: 1.00, green: 0.12, blue: 0.70, alpha: 1.0)
    static let gradient4 = #colorLiteral(red: 0.77, green: 0.22, blue: 0.91, alpha: 1.0)
    
    static let switchTintColor = #colorLiteral(red: 0, green: 0.8, blue: 0.47, alpha: 1)

    
    static var containerBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.lightBackground : AppColor.lightBackground
        }
    }

    static var appBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.appLightBackground : AppColor.appLightBackground
        }
    }

    static var tabBarBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.lightTabBarBackground : AppColor.lightTabBarBackground
        }
    }

    static var mainFont: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.mainFontDark : AppColor.mainFontDark
        }
    }

    static var secondaryFont: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.secondaryFontDark : AppColor.secondaryFontDark
        }
    }

    static var tetrialyFont: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.tetrialyFontDark : AppColor.tetrialyFontDark
        }
    }

    static var appGreen: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.greenBlue : AppColor.greenBlue
        }
    }

    static var appYellow: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.butterScotch : AppColor.butterScotch
        }
    }

    static var appBlack: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.black : AppColor.black
        }
    }

    static var appRed: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.cherry : AppColor.cherry
        }
    }

    static var appWhite: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.white : AppColor.white
        }
    }

    static var appBlue: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.blue : AppColor.blue
        }
    }

    static var appBlueLight: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.blueLight : AppColor.blueLight
        }
    }

    static var defaultByMarker: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? AppColor.defaultByMarker : AppColor.defaultByMarker
        }
    }
}
