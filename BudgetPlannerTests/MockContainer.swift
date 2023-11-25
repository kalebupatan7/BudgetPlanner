//
//  MockContainer.swift
//  BudgetPlannerTests
//
//  Created by Kalebu Patan on 11/24/23.
//

import Foundation
import SwiftData

@MainActor
var mockContainer: ModelContainer {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Budget.self, Expense.self, People.self, PeopleWithMoney.self, configurations: config, config, config, config)
        return container
    } catch {
        fatalError("Failed to create container")
    }
}
