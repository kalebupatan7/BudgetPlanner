//
//  ExpenseView.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/23/23.
//

import SwiftUI

struct ExpenseView: View {
    
    @Environment(CurrencyChange.self) private var currencyChange
    @State var expense: Expense
    
    var body: some View {
        List {
            Section("PAID BY") {
                if let name = expense.paidBy?.people?.name {
                    Text(name)
                }
            }
            Section("EXPENSE AMOUNT") {
                if let amount = expense.amount {
                    Text((currencyChange.currency.getCurrencyValue * amount).formatted(.currency(code: currencyChange.currency.rawValue)))
                }
            }
            
            Section("DATE") {
                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
            }
            
            Section("SHARES") {
                ForEach(expense.shares) { people in
                    Text("\(people.people?.name ?? "")'s share:  \((currencyChange.currency.getCurrencyValue * (people.settled ?? 0)).formatted(.currency(code: currencyChange.currency.rawValue)))")
                }
            }
            
            Section("RECEIPT") {
                if let receipt = expense.receipt, let uiImage = UIImage(data: receipt) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .navigationTitle(expense.name)
    }
}

#Preview {
    ExpenseView(expense: Expense())
}
