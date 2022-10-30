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
    
    @State var logToEdit: ExpenseLog?
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @FetchRequest(
        entity: ExpenseLog.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)
        ]
    )
    private var result: FetchedResults<ExpenseLog>
    private var groupedResult = [String: [ExpenseLog]]()
    
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
        List {
            if listItems.isEmpty {
                Text("Oops, loos like there's no data...")
                //                Image(systemName: "signature.zh")
            }
            ForEach(listItems.keys.sorted(), id: \.self) { key in
                Section {
                    ExpansesListItemView(title: key, items: listItems[key] ?? [])
                }
            }
        }
    }
    
    private func onDelete(with indexSet: IndexSet) {
        indexSet.forEach { index in
            let log = result[index]
            context.delete(log)
        }
        try? context.saveContext()
    }
    
    private func convertToGroupedArray() -> [String: [ExpenseLog]] {
        let dictionar = Dictionary(grouping: result) { $0.dateString ?? "" }
        return dictionar
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
