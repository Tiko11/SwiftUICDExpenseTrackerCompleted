//
//  ExpansesListItemView.swift
//  ExpenseTracker
//
//  Created by Tinatini Charkviani on 30.10.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI


struct ExpansesListItemView: View {
    
    @State private var title: String
    @State private var items: [ExpenseLog]
    
    init(title: String, items: [ExpenseLog]) {
        self.title = title
        self.items = items
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Text(title).font(.flexaMono(.bold))
        }
        ForEach(items) { (log: ExpenseLog) in
            Button(action: {
            }) {
                HStack(spacing: 16) {
                    CategoryImageView(category: log.categoryEnum)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(log.nameText).font(.flexaMono())
                        Text(log.dateText).font(.flexaMono(.medium, .small))
                    }
                    Spacer()
                    Text(log.amountText).font(.flexaMono())
                }
                .padding(.vertical, 4)
            }
        }
    }
}

struct ExpansesListItemView_Previews: PreviewProvider {
    static var previews: some View {
        return ExpansesListItemView(title: "", items: [])
    }
}
