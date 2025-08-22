//
//  Expense+Extensions.swift
//  Budget
//
//  Created by Isha Nailwal on 12/07/25.
//

import Swift
import CoreData

extension Expense {
    var total: Double {
        amount * Double(quantity)
    }
}
