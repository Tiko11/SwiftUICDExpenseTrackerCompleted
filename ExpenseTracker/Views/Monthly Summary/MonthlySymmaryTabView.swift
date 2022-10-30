//
//  MonthlySymmary.swift
//  ExpenseTracker
//
//  Created by Tinatini Charkviani on 30.10.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData


struct MonthlySymmaryTabView: View {
    
    @State var selectedMonths: Set<Month> = Set()
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Divider()
                Text(" 20 000$ ").font(.largeTitle).fontWeight(.bold)
                Text(" Feb, Mar, May")
            }
            
            VStack(spacing: 8) {
                MonthsView(selectedMonths: $selectedMonths)
            }
            
            VStack(spacing: 5) {
                ExpensesListView(predicate: ExpenseLog.predicate(with: Array(selectedMonths), searchText: ""),
                                 sortDescriptor: ExpenseLogSort(sortType: .date, sortOrder: .ascending).sortDescriptor)
            }
        }.padding(.top)
    }
}

struct MonthlySymmary_Previews: PreviewProvider {
    static var previews: some View {
        MonthlySymmaryTabView()
    }
}

