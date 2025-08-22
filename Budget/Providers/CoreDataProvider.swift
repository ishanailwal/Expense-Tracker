//
//  CoreDataProvider.swift
//  Budget
//
//  Created by Isha Nailwal on 27/04/25.
//

import Foundation
import CoreData

class CoreDataProvider {
    
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static var preview: CoreDataProvider = {
        let provider = CoreDataProvider()
        let context = provider.context
        
        let entertainment = Budget(context: context)
        entertainment.title = "Entertainment"
        entertainment.limit = 500
        entertainment.dateCreated = Date()
        
        let milk = Expense(context: context)
        milk.title = "Milk"
        milk.amount = 50
        milk.dateCreated = Date()
        
        let cookies = Expense(context: context)
        cookies.title = "Milk"
        cookies.amount = 50
        cookies.dateCreated = Date()
        
        entertainment.addToExpenses(milk)
        entertainment.addToExpenses(cookies)
        
        let commonTags = ["food", "shopping", "travel", "health", "education", "utilities", "groceries", "rent"]
        
        for commonTag in commonTags {
            let tag = Tag(context: context)
            tag.name = commonTag
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        return provider
    }()
    
    init(inMemory: Bool = false) {
        
        persistentContainer = NSPersistentContainer(name: "BudgetAppModel")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core data store failed to initialise \(error)")
            }
        }
    }
}
