//
//  LogFormView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogFormView: View {
    
    var logToEdit: ExpenseLog?
    var context: NSManagedObjectContext
    
    @State var name: String = ""
    @State var amount: Double = 0
    @State var category: Category = .utilities
    @State var date: Date = Date()
    @State var notes: String = ""
    
    @Environment(\.presentationMode)
    var presentationMode
    
    var title: String {
        logToEdit == nil ? "Create Expense Log" : "Edit Expense Log"
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name).font(.flexaMono())
                    .disableAutocorrection(true)
                TextField("Amount", value: $amount, formatter: Utils.numberFormatter()).font(.flexaMono())
                    .keyboardType(.numbersAndPunctuation)
                    
                Picker(selection: $category, label: Text("Category").defaultFont()) {
                    ForEach(Category.allCases) { category in
                        Text(category.rawValue.capitalized).defaultFont().tag(category)
                    }
                }
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Date").font(.flexaMono())
                }
                TextField("Notes", text: $notes).font(.flexaMono())
                    .disableAutocorrection(true)
            }

            .navigationBarItems(
                leading: Button(action: self.onCancelTapped) { Text("Cancel").font(.flexaMono()) },
                trailing: Button(action: self.onSaveTapped) { Text("Save").font(.flexaMono()) }
            ).navigationBarTitle(title)
            
        }
        
    }
    
    private func onCancelTapped() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func onSaveTapped() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        let log: ExpenseLog
        if let logToEdit = self.logToEdit {
            log = logToEdit
        } else {
            log = ExpenseLog(context: self.context)
            log.id = UUID()
        }
        
        log.name = self.name
        log.category = self.category.rawValue
        log.amount = NSDecimalNumber(value: self.amount)
        log.date = self.date
        log.dateString = Utils.dateStringFormatter.string(from: self.date)
        log.notes = self.notes
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct LogFormView_Previews: PreviewProvider {
    static var previews: some View {
        let stack = CoreDataStack(containerName: "ExpenseTracker")
        return LogFormView(context: stack.viewContext)
    }
}
