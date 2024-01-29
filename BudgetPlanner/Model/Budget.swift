//
//  Budget.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/14/23.
//

import Foundation
import SwiftData

@Model
final class Budget {
    var name: String
    var from: Date
    var to: Date
    var peoples = [People]()
    @Relationship var expenses = [Expense]()

    init(name: String = K.emptyString, from: Date = Date(), to: Date = Date().addingTimeInterval(24*60*60), expenses: [Expense] = [Expense](), peoples:[People] = [People]()) {
        self.name = name
        self.from = from
        self.to = to
        self.expenses = expenses
        self.peoples = peoples
    }
}
