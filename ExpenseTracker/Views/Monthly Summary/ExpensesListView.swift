//
//  ExpensesListView.swift
//  ExpenseTracker
//
//  Created by Tinatini Charkviani on 30.10.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct ExpensesListView: View {
    @FetchRequest(
        entity: ExpenseLog.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)
        ]
    )
    private var result: FetchedResults<ExpenseLog>
    
    init(predicate: NSPredicate?, sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<ExpenseLog>(entityName: ExpenseLog.entity().name ?? "ExpenseLog")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        _result = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        let listItems = convertToGroupedArray()
        let sum = result.map { $0.amount as? Double ?? 0.0 }.reduce(0, +)
        
        VStack(spacing: 10) {
            Text("Total: " + sum.formattedCurrencyText).font(.flexaMono(.bold, .large)).animation(Animation.spring())
        }.padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.purple.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .frame(height: 44)
        List {
            if listItems.isEmpty {
                Text("Oops, loos like there's no data...").font(.flexaMono(.medium,.standard)).animation(.spring())
            }
            
            ForEach(listItems.keys.sorted(), id: \.self) { key in
                Section {
                    ExpansesListItemView(title: key, items: listItems[key] ?? []).animation(.easeInOut)
                }
            }
        }
    }
    
    private func convertToGroupedArray() -> [String: [ExpenseLog]] {
        let dictionary = Dictionary(grouping: result) { $0.dateString ?? "" }
        return dictionary
    }
}

struct ExpensesListView_Previews: PreviewProvider {
    static var previews: some View {
        let stack = CoreDataStack(containerName: "ExpenseTracker")
        let sortDescriptor = ExpenseLogSort(sortType: .date, sortOrder: .descending).sortDescriptor
        return ExpensesListView(predicate: nil, sortDescriptor: sortDescriptor)
            .environment(\.managedObjectContext, stack.viewContext)
    }
}
