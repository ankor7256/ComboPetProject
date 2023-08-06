//
//  UIColor+HEX.swift
//  CustomCollectionExample
//
//  Created by Andrey Korotkov on 28.10.2021.
//

import UIKit.UIColor

extension UIColor {

    convenience init(withHexString hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        switch cString.count {
        case 6:
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: CGFloat(1.0))
        case 8:
            self.init(
                red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgbValue & 0x000000FF) / 255.0)
        default:
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )

        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }

    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

    convenience init(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
        let components = (
            R: r/255.0,
            G: g/255.0,
            B: b/255.0
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: a)
    }

    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue, alpha)
        } else {
            return nil
        }
    }

    static func color(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hexString: hex, alpha: alpha)
    }

    static var randomfromPalittre: UIColor {
        let colorsArray: [UIColor] = [UIColor.middleBlue, UIColor.greenlandGreen, UIColor.exodusFruit, UIColor.blurple, UIColor.carminePink, UIColor.pinkGlamour]
        return colorsArray.randomElement() ?? .white
    }
}
