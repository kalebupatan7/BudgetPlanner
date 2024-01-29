//
//  Expense.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/14/23.
//

import Foundation
import SwiftData

@Model
final class Expense {
    var name: String
    @Relationship var paidBy: PeopleWithMoney?
    var amount: Decimal?
    var date: Date
    @Relationship var shares = [PeopleWithMoney]()
    var receipt: Data?
    
    init(name: String = K.emptyString, paidBy: PeopleWithMoney? = nil, amount: Decimal? = nil, date: Date = Date(), shares: [PeopleWithMoney] = [PeopleWithMoney](), receipt: Data? = nil) {
        self.name = name
        self.paidBy = paidBy
        self.amount = amount
        self.date = date
        self.shares = shares
        self.receipt = receipt
    }
}
