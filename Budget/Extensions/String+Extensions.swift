//
//  File.swift
//  Budget
//
//  Created by Isha Nailwal on 27/04/25.
//

import Foundation

extension String {
    
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
