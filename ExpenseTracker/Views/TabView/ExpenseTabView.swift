//
//  ExpenseTabView.swift
//  ExpenseTracker
//
//  Created by Tinatini Charkviani on 30.10.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI

struct ExpenseTabView: View {
    
    private let viewModel = ViewModel()
    
    var body: some View {
        TabView {
            let items = viewModel.items
            DashboardTabView().create(item: items[0])
            LogsTabView().create(item: items[1])
            MonthlySymmaryTabView().create(item: items[2])
        }.accentColor(Colors.mainBlue)
    }
}

struct ExpenseTabView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseTabView()
    }
}
