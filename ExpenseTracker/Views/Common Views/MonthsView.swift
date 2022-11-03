//
//  MonthsView.swift
//  ExpenseTracker
//
//  Created by Tinatini Charkviani on 30.10.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI

struct MonthsView: View {

    @Binding var selectedMonths: Set<Month>
    
    var body: some View {
        let months = setupMonths()
        Text("Months").font(.flexaMono(.bold, .headline))
        let gridLayout = [GridItem(.flexible()),
                          GridItem(.flexible()),
                          GridItem(.flexible()),
                          GridItem(.flexible())]
        LazyVGrid(columns: gridLayout, alignment: .center, spacing: 12) {
                ForEach(months) { month in
                    MonthView(
                        month: month,
                        isSelected: self.selectedMonths.contains(month),
                        onTap: self.onTap
                    )
                }
            }
    }
    
    func onTap(category: Month) {
        if selectedMonths.contains(category) {
            selectedMonths.remove(category)
        } else {
            selectedMonths.insert(category)
        }
    }
    
    private func setupMonths()-> [Month] {
        let nameOfMonth = Utils.monthFormatter.string(from: Date())
        var values: [Month] = Month.allCases
        if let currentMonth = values.filter({ $0.name == nameOfMonth }).first {
            let offset = currentMonth.rawValue
            let tempResult = values[offset...] + values[..<offset]
            values = Array(tempResult)
        }

        return values
    }
}

struct MonthView: View {
    
    var month: Month
    var isSelected: Bool
    var onTap: (Month) -> ()
    
    var body: some View {
        Button(action: {
            self.onTap(self.month)
        }) {
            HStack(spacing: 8) {
                Text(month.shortName).defaultFont().foregroundColor(isSelected ? Color(.white) : Color(.black))
                    .fixedSize(horizontal: true,
                               vertical: true)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background((isSelected ? Colors.mainBlue : Color(.white)))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(isSelected ? Colors.mainBlue : Color(.black), lineWidth: 1))
            .frame(height: 44)
        }
        .foregroundColor(isSelected ? Colors.mainBlue : Color(.black))
    }
}

struct MonthsView_Previews: PreviewProvider {
    static var previews: some View {
        MonthsView(selectedMonths: .constant(Set<Month>()))
    }
}
