//
//  BudgetPlannerApp.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/13/23.
//

import SwiftUI

@main
struct BudgetPlannerApp: App {
   
    @State private var currencyChange = CurrencyChange()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(currencyChange)
        }
        .modelContainer(for: [Budget.self, Expense.self, People.self, PeopleWithMoney.self])
    }
}
