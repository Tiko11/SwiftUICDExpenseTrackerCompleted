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
            Divider().background(Color.black)
            MonthsView(selectedMonths: $selectedMonths)
            
            ExpensesListView(predicate: ExpenseLog.predicate(with: Array(selectedMonths), searchText: ""),
                             sortDescriptor: ExpenseLogSort(sortType: .date, sortOrder: .ascending).sortDescriptor)
        }.padding(.top)
    }
}

struct MonthlySymmary_Previews: PreviewProvider {
    static var previews: some View {
        MonthlySymmaryTabView()
    }
}

