//
//  ExpanseTabViewModel.swift
//  ExpenseTracker
//
//  Created by Tinatini Charkviani on 30.10.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI

struct TabBarItem {
    var title, imageName: String
    var tag: Int
}

extension ExpenseTabView {
    class ViewModel {
        var items: [TabBarItem] =  [TabBarItem(title: "Dashboard",
                                               imageName: "chart.pie",
                                               tag: 0),
                                    TabBarItem(title: "Logs",
                                               imageName: "tray",
                                               tag: 1),
                                    TabBarItem(title: "Monthly Summary",
                                               imageName: "chart.bar",
                                               tag: 2)
        ]
    }
}
