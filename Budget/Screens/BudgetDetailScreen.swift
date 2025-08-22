//
//  BudgetDetailScreen.swift
//  Budget
//
//  Created by Isha Nailwal on 27/04/25.
//

import SwiftUI

struct BudgetDetailScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    init (budget: Budget) {
        self.budget = budget
        _expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
    }
    
    let budget: Budget
    
    @State var title: String = ""
    @State var amount: Double?
    @State var quantity: Int?
    @State var expenseToEdit: Expense?
    @State private var selectedTags: Set<Tag> = []
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && amount != nil && Double(amount!) > 0 && !selectedTags.isEmpty && quantity != nil && Int(quantity!) > 0
    }
    
    private var total: Double {
        return expenses.reduce(0) { result, expense in
            expense.amount + result
        }
    }
    private var remaining: Double {
        return budget.limit - total
    }
    
    private func addExpense() {
        let expense = Expense(context: context)
        
        expense.title = title
        expense.amount = amount ?? 0.0
        expense.quantity = Int16(quantity ?? 0)
        expense.dateCreated = Date()
        expense.tag = NSSet(array: Array(selectedTags))
        
        budget.addToExpenses(expense)
        
        do {
            try context.save()
            title = ""
            amount = nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteExpense(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let expense = expenses[index]
            context.delete(expense)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        Form {
            Section("New expense") {
                TextField("Title", text: $title)
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.numberPad)
                TextField("Quantity", value: $quantity, format: .number)
                
                TagsView(selectedTags: $selectedTags)
                    .environment(\.managedObjectContext, context)
                
                Button {
                    addExpense()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }.buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
            }
            
            Section("Expenses") {
                List {
                    VStack {
                        Text(total, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        Text(remaining, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                    ForEach(expenses) { expense in
                        ExpenseRow(expense: expense)
                            .onLongPressGesture {
                                expenseToEdit = expense
                            }
                    }.onDelete(perform: deleteExpense)
                }
                
            }
        }.navigationTitle(budget.title ?? "")
            .sheet(item: $expenseToEdit) { expenseToEdit in
                NavigationStack {
                    EditExpenseScreen(expense: expenseToEdit)
                }
            }
    }
}

struct BudgetDetailScreenContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    
    var body: some View {
        BudgetDetailScreen(budget: budgets[0])
    }
}


#Preview {
    NavigationStack {
        BudgetDetailScreenContainer()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}
