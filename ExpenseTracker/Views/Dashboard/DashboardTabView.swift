//
//  DashboardTabView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

enum DashboardStates: Equatable {
    case loaded, isLoading, error(message: String)
}

struct DashboardTabView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @State var totalExpenses: Double?
    @State var categoriesSum: [CategorySum]?
    @State private var isEnabled = false
    @State private var group = DispatchGroup()
    @State private var state: DashboardStates = .loaded
    
    var body: some View {
        VStack {
            if state != .loaded {
                addProcessingView()
            } else {
                VStack(spacing: 0) {
                    createHeader()
                    createListWrapper()
                    if totalExpenses != nil || categoriesSum != nil {
                        Divider().background(Color.black)
                    }
                }
            }
        }
        .padding(.top)
        .onAppear(perform: fetchCurrencies)
    }
    
    func fetchTotalSums() {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: self.context) { (results) in
            guard !results.isEmpty else { return }
            let totalSum = results.map { $0.sum }.reduce(0, +)
            self.totalExpenses = totalSum
            self.categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: result.sum, category: result.category)
            })
            state = .loaded
        }
    }
    
    func fetchCurrencies() {
        guard isEnabled else {
            Utils.currencySymbol = .usd
            fetchTotalSums()
            return
        }
        state = .isLoading
        let repository = CurrencyRepository()
        group.enter()
        repository.convertCurrency(amount: totalExpenses ?? 0.0, isEnabled: isEnabled) { newValue, errorMessage in
            if let message = errorMessage {
                Utils.currencySymbol = .usd
                state = .error(message: message)
            } else {
                self.totalExpenses = newValue?.amount ?? 0.0
            }
            group.leave()
        }
        
        group.enter()
        guard var sums = categoriesSum else { return }
        for i in 0..<sums.count {
            group.enter()
            repository.convertCurrency(amount: sums[i].sum, isEnabled: isEnabled) { newValue, errorMessage in
                if let message = errorMessage {
                    Utils.currencySymbol = .usd
                    state = .error(message: message)
                } else {
                    sums[i].sum = newValue?.amount ?? 0.0
                    if i == sums.count - 1 {
                        Utils.currencySymbol = .euro
                        categoriesSum = sums
                        state = .loaded
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            Utils.currencySymbol = .euro
            categoriesSum = sums
        }
    }
    
    fileprivate func createEuroSwitcher() -> some View {
        return ZStack {
            Capsule()
                .frame(width: 60, height: 30)
                .foregroundColor(Colors.mainBlue)
            ZStack{
                Circle()
                    .frame(width:27, height: 27)
                    .foregroundColor(.white)
                Image(systemName: isEnabled ? "eurosign.circle" : "dollarsign.circle").foregroundColor(Color.black)
            }
            .offset(x: isEnabled ? 12 : -12)
            .padding(18)
            .animation(.spring())
        }
        .onTapGesture {
                self.isEnabled.toggle()
                self.fetchCurrencies()
        }
    }
    
    
    private func createHeader() -> some View {
        VStack(spacing: 4) {
            HStack {
                VStack {
                    if let expanses = totalExpenses {
                        Text("Total expenses")
                            .font(.flexaMono(.bold, .headline))
                        
                        Text(expanses.formattedCurrencyText)
                            .font(.flexaMono(.bold, .large))
                    }
                }
                
                if totalExpenses != nil || categoriesSum != nil {
                    createEuroSwitcher()
                }
            }
            
            if let sum = categoriesSum, let expanses = totalExpenses, expanses > 0 {
                PieChartView(
                    data: sum.map { ($0.sum, $0.category.color) },
                    style: Styles.pieChartStyleOne,
                    form: CGSize(width: 300, height: 240),
                    dropShadow: false
                )
            }
        }
    }
    
    private func createListWrapper() -> some View {
        VStack(spacing: 4) {
            if categoriesSum != nil {
                List {
                    Text("Breakdown").font(.flexaMono(.bold, .headline))
                    ForEach(self.categoriesSum!) {
                        CategoryRowView(category: $0.category, sum: $0.sum)
                    }
                }
            }
            if totalExpenses == nil && categoriesSum == nil {
                Text("No expenses data\nPlease add your expenses from the logs tab")
                    .multilineTextAlignment(.center)
                    .font(.flexaMono(.bold, .headline))
                    .padding(.horizontal)
            }
        }
    }
    
    
    private func addProcessingView() -> some View {
        ZStack {
            if state == .isLoading {
                ProgressView()
            } else {
                switch state {
                    case .error(let message):
                        Text(message).defaultFont()
                    default:
                        Text("Try again later").defaultFont()
                }
            }
        }
    }
}


struct CategorySum: Identifiable, Equatable {
    var sum: Double
    let category: Category
    
    var id: String { "\(category)\(sum)" }
}


struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView()
    }
}
