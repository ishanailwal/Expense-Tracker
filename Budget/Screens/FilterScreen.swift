//
//  FilterScreen.swift
//  Budget
//
//  Created by Isha Nailwal on 08/06/25.
//

import SwiftUI

struct FilterScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    @State private var selectedTags: Set<Tag> = []
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    @State private var filteredExpenses: [Expense] = []
    
    @State private var startPrice: Double?
    @State private var endPrice: Double?
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @State private var title: String = ""
    @State private var selectedSortOption: SortOptions? = nil
    @State private var selectedSortDirection: SortDirection = .asc
    
    private enum SortDirection: Identifiable, CaseIterable {
        case asc
        case desc
        
        var id: SortDirection {
            return self
        }
        
        var title: String {
            switch self {
                case .asc:
                    return "Ascending"
                case .desc:
                    return "Descending"
            }
        }
    }
    
    private enum SortOptions: Identifiable, CaseIterable {
        case title
        case date
        
        var id: SortOptions {
            return self
        }
        
        var title: String {
            switch self {
                case .title:
                    return "Title"
                case .date:
                    return "Date"
            }
        }
        
        var key: String {
            switch self {
                case .title:
                    return "title"
                case .date:
                    return "dateCreated"
            }
        }
    }
    
    private func filterTags() {
        let selectedTagNames = selectedTags.map { $0.name }
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "ANY tag.name IN %@", selectedTagNames)
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByPrice() {
        guard let startPrice = startPrice, let endPrice = endPrice else
        {return}
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: startPrice), NSNumber(value: endPrice))
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByTitle() {
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByDate() {
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func performSort() {
        guard let sortOption = selectedSortOption else {
            return
        }
        
        let request = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: sortOption.key, ascending: selectedSortDirection == .asc ? true : false)]
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        List {
            
            Section("Sort") {
                Picker("Sort Options", selection: $selectedSortOption) {
                    Text("Select").tag(Optional<SortOptions>(nil))
                    ForEach(SortOptions.allCases) { option in
                        Text(option.title).tag(Optional(option))
                    }
                }
                
                Picker("Sort Direction", selection: $selectedSortDirection) {
                    Text("Select").tag(Optional<SortOptions>(nil))
                    ForEach(SortDirection.allCases) { option in
                        Text(option.title)
                            .tag(option)
                    }
                }
                
                Button("Sort") {
                    performSort()
                }
            }
            
            Section("Filter By Tags") {
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags, filterTags)
            }
            
            Section("Filter By Price") {
                TextField("Start Price", value: $startPrice, format: .number)
                TextField("End Price", value: $endPrice, format: .number)
                Button("Search") {
                    filterByPrice()
                }
            }
            
            Section("Filter By Title") {
                TextField("Title", text: $title)
                Button("Search") {
                    filterByTitle()
                }
            }
            
            Section("Filter By Date") {
                DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                DatePicker("End date", selection: $endDate, displayedComponents: .date)
                
                Button("Search") {
                    filterByDate()
                }
            }
            
            Section("Expenses") {
                ForEach(filteredExpenses) { expense in
                    ExpenseRow(expense: expense)
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Show All") {
                    selectedTags = []
                    filteredExpenses = expenses.map { $0 }
                }
                Spacer()
            }
        }.padding()
            .navigationTitle("Filter")
    }
}

#Preview {
    FilterScreen()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
