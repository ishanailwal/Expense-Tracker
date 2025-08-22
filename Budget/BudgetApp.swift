//
//  BudgetApp.swift
//  Budget
//
//  Created by Isha Nailwal on 27/04/25.
//

import SwiftUI

@main
struct BudgetApp: App {
    
    let provider: CoreDataProvider
    let tagSeeder: TagsSeeders
    
    init() {
//        UserDefaults.standard.setValue(false, forKey: "hasSeedData")
        provider = CoreDataProvider(inMemory: false)
        tagSeeder = TagsSeeders(context: provider.context)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BudgetListScreen()
                    .onAppear() {
                        let hasSeededData = UserDefaults.standard.bool(forKey: "hasSeedData")
                        if !hasSeededData {
                            let commontags = ["food", "shopping", "travel", "health"]
                            do {
                                try tagSeeder.seed(commontags)
                                print("tags seeded")
                                UserDefaults.standard.setValue(false, forKey: "hasSeedData")
                            } catch {
                                print("Failed to seed tags")
                            }
                        } else {
                            print("tags already seeded")
                        }
                    }
            }.environment(\.managedObjectContext, provider.context)
        }
    }
}
