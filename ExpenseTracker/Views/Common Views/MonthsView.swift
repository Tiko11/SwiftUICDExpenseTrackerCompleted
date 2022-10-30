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
    private let months = Month.allCases
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(months) { month in
                    MonthView(
                        month: month,
                        isSelected: self.selectedMonths.contains(month),
                        onTap: self.onTap
                    )
                    
                    .padding(.leading, month == self.months.first ? 16 : 0)
                    .padding(.trailing, month == self.months.last ? 16 : 0)
                    
                }
            }
        }
        .padding(.vertical)
    }
    
    func onTap(category: Month) {
        if selectedMonths.contains(category) {
            selectedMonths.remove(category)
        } else {
            selectedMonths.insert(category)
        }
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
                Text(month.shortName)
                    .fixedSize(horizontal: true, vertical: true)
                
                if isSelected {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(UIColor.blue) : Color(UIColor.lightGray), lineWidth: 1))
            .frame(height: 44)
        }
        .foregroundColor(isSelected ? Color(UIColor.blue) : Color(UIColor.gray))
    }
    
    
}


struct MonthsView_Previews: PreviewProvider {
    static var previews: some View {
        MonthsView(selectedMonths: .constant(Set()))
    }
}
