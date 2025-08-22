//
//  ExpenseRow.swift
//  Budget
//
//  Created by Isha Nailwal on 01/06/25.
//

import SwiftUI

struct ExpenseRow: View {
    
    @ObservedObject var expense: Expense
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(expense.title ?? "")
                Text("(\(expense.quantity))")
                Spacer()
                Text(expense.total, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }.contentShape(Rectangle())
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(expense.tag as? Set<Tag> ?? [])) { tag in
                        Text(tag.name ?? "")
                    }
                }
            }
        }
    }
}

struct ExpenseRowContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    var body: some View {
        ExpenseRow(expense: expenses[1])
    }
}

#Preview {
    ExpenseRowContainer()
}
