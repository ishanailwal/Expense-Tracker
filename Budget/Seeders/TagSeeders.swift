//
//  TagSeeders.swift
//  Budget
//
//  Created by Isha Nailwal on 01/05/25.
//

import Foundation
import CoreData

class TagsSeeders {
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func seed(_ commonTags: [String]) throws {
        
        for commonTag in commonTags {
            let tag = Tag(context: context)
            tag.name = commonTag
        }
        try context.save()
    }
}
