//
//  Colors.swift
//  TableViewExample
//
//  Created by Andrew K on 3/16/23.
//

import UIKit

extension UIColor {
    static var middleBlue: UIColor { return color(hex: "7ed6df")}
    static var greenlandGreen: UIColor { return color(hex: "22a6b3")}
    static var exodusFruit: UIColor { return color(hex: "686de0")}
    static var blurple: UIColor { return color(hex: "4834d4")}
    static var carminePink: UIColor { return color(hex: "eb4d4b")}
    static var pinkGlamour: UIColor { return color(hex: "ff7979")}
    static var noActivButton: UIColor { return color(hex: "E9E9E9")}
    static var mustard: UIColor { return color(hex: "#F1C249") }
    static var blackEvent: UIColor { return color(hex: "#263238")}
    static var gray: UIColor { return color(hex: "#505050")}
    static var inputTextGray: UIColor { return color(hex: "#A8A8AE")  }
    static var inputBackgroundGray: UIColor { return color(hex: "#F6F6F6") }
    static var inactiveButtonGray: UIColor { return color(hex: "#E9E9E9") }
    static var error: UIColor { return color(hex: "#FC6565")}
    static var inactiveCollectionCell: UIColor { return color(hex: "#F5F5F5") }
    static var activeCollectionell: UIColor { return color(hex: "#FFECBD") }
    static var inactiveCheckMarkGray: UIColor { return color(hex: "#EBEBEA") }
    static var toastError: UIColor { return color(hex: "#F14949") }
    static var toastNeutral: UIColor { return color(hex: "#263238") }
    static var toastSuccess: UIColor { return color(hex: "#286F6C") }
    static var backgroundBehindTheAlert: UIColor { return color(hex: "#050505") }
    static var mainBackgroundColor: UIColor { return color(hex: "#F9F9F9") }
    static var placeholderTextColor: UIColor { return color(hex: "#A5A5A5") }
    static var collectionCellGradient: UIColor { return color(hex: "#000000") }
    static var eventNonActivePagingIndicator: UIColor { return color(hex: "#FFFFFF", alpha: 0.3) }
    static var onboardingPaginationViewCommonColor: UIColor { return color(hex: "#C89105") }
    static var splashLoaderBackground: UIColor { return color(hex: "#EBEBEB")}
    static var checkedFilterButton: UIColor { return color(hex: "#FFF2D8") }
    static var createEventPlugBackground: UIColor { return color(hex: "#F1F1F1")}
    static var referalViewBackground: UIColor { return color(hex: "#FFFAEF")}
    static var deleteAccountAlert: UIColor {return color(hex: "#FB5656")}
    static var messageDefault: UIColor {return color(hex: "#F9F9F9")}
    static var messageHighlighted: UIColor {return color(hex: "#FFF9ED")}
}

extension UIColor {
    static var random: UIColor {
        let colorsArray: [UIColor] = [UIColor.middleBlue, UIColor.greenlandGreen, UIColor.exodusFruit, UIColor.blurple, UIColor.carminePink, UIColor.pinkGlamour]
        return colorsArray.randomElement() ?? .white
    }
}
