//
//  People.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/14/23.
//

import Foundation
import SwiftData

@Model
final class People {
    var name: String
    var email: String
    var settled: Decimal?
    var dateAdded = Date()
    var isSelected = false
    init(name: String, email:String, isSelected:Bool = false, settled: Decimal? = nil) {
        self.name = name
        self.email = email
        self.isSelected = isSelected
        self.settled = settled
    }
}

@Model
final class PeopleWithMoney {
    var people: People?
    var settled: Decimal?
    init(people: People? = nil, settled: Decimal? = nil) {
        self.people = people
        self.settled = settled
    }
}
