//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation
import SwiftUI

extension Double {
    var formattedCurrencyText: String {
        return Utils.numberFormatter().string(from: NSNumber(value: self)) ?? "0"
    }
}

extension View {
    func create(item: TabBarItem) -> some View {
        tabItem {
            VStack {
                Text(item.title).font(.flexaMono())
                Image(systemName: item.imageName)
            }
        }.tag(item.tag)
    }
}

extension Font {
    
    enum FontType : String {
        case medium = "Md"
        case regular = "Rg"
        case bold = "Bd"
        case mediumItalic = "MdIt"
        case regularItalic = "RgIt"
        case boldItalic = "BdIt"
    }
    
    enum FontSize: Int {
        case tiny = 12
        case small = 14
        case standard = 15
        case large = 16
        case headline = 18
    }
    
    static func flexaMono(_ type: FontType = .medium,
                          _ size: FontSize = .standard) -> Font? {
        return Font.custom("GTFlexaMonoTrial-" + type.rawValue,
                           size: CGFloat(size.rawValue))
    }
}

extension UIFont {
    static func flexa(size: CGFloat = 12) -> UIFont? {
        return UIFont(name: "GTFlexaMonoTrial-Md",
                      size: 12)
    }
}

extension Text {
    func defaultFont() -> some View {
        self.font(.flexaMono())
    }
}
