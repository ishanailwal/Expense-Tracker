//
//  BudgetListScreen.swift
//  Budget
//
//  Created by Isha Nailwal on 27/04/25.
//

import SwiftUI

struct BudgetListScreen: View {
    
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    @State var isPresented: Bool = false
    @State var isFilterPresented: Bool = false
    
    private var total: Double {
        budgets.reduce(0) { limit, budget in
            budget.limit + limit
        }
    }
    
    var body: some View {
        VStack {
            
            if budgets.isEmpty {
                ContentUnavailableView("No Budgets available", systemImage: "list.clipboard")
            } else {
                List {
                    HStack {
                        Text("Total Limit")
                        Text(total, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        Spacer()
                    }.font(.headline)
                    ForEach(budgets) { budget in
                        NavigationLink {
                            BudgetDetailScreen(budget: budget)
                        } label: {
                            BudgetRow(budget: budget)
                        }
                    }
                }
            }
        }
        .overlay(alignment: .bottom, content: {
            Button("Filter") {
                isFilterPresented = true
            }
        })
        .navigationTitle("Budget App")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Budget") {
                        isPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                AddBudgetScreen()
            }
            .sheet(isPresented: $isFilterPresented) {
                NavigationStack {
                    FilterScreen()
                }
            }
    }
}

#Preview {
    NavigationStack {
        BudgetListScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

struct BudgetRow: View {
    
    let budget: Budget
    
    var body: some View {
        HStack {
            Text(budget.title ?? "")
            Spacer()
            Text(budget.limit, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
    }
}
