//
//  Grade.swift
//  BoulderingApp
//
//  Created by Przemyslaw Idziak on 08/11/2026.
//

import Foundation

struct Grade: Comparable, Hashable {
    var baseScore: Int
    
    static func < (lhs: Grade, rhs: Grade) -> Bool {
        return lhs.baseScore < rhs.baseScore
    }
}
