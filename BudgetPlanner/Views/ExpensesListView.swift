//
//  ExpensesListView.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/22/23.
//

import SwiftUI
import SwiftData

struct ExpensesListView: View {
    @Environment(CurrencyChange.self) private var currencyChange
    @Environment(\.modelContext) var modelContext
    @State private var visibility: NavigationSplitViewVisibility = .all
    @Bindable var budget:Budget
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($budget.wrappedValue.expenses) { expense in
                    NavigationLink(destination: ExpenseView(expense: expense)) {
                        VStack(alignment: .leading) {
                            Text(expense.name)
                                .font(.headline)
                            if let paidby = expense.paidBy?.people?.name, let amount = expense.amount {
                                Text(paidby+K.paid+(currencyChange.currency.getCurrencyValue * amount).formatted(.currency(code: currencyChange.currency.currencyString)))
                            }
                        }
                    }
                }
                .onDelete(perform: deleteExpenses)
            }
        }
        .navigationTitle(K.expenses)
        .toolbar {
            NavigationLink(destination: AddExpenseView(budget: budget)) { Image(systemName: K.plusIcon)
                    .foregroundColor(.black)
            }
        }
    }

    func deleteExpenses(_ indexSet: IndexSet) {
        for index in indexSet {
            budget.expenses.remove(at: index)
        }
    }
}

