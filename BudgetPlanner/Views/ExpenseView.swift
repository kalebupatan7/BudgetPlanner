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
            Section(K.paidBy) {
                if let name = expense.paidBy?.people?.name {
                    Text(name)
                }
            }
            Section(K.expenseAmount) {
                if let amount = expense.amount {
                    Text((currencyChange.currency.getCurrencyValue * amount).formatted(.currency(code: currencyChange.currency.currencyString)))
                }
            }
            
            Section(K.date) {
                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
            }
            
            Section(K.shares) {
                ForEach(expense.shares) { people in
                    Text((people.people?.name ?? K.emptyString)+K.personShares+((currencyChange.currency.getCurrencyValue * (people.settled ?? 0)).formatted(.currency(code: currencyChange.currency.currencyString))))
                }
            }
            
            Section(K.receipt) {
                if let receipt = expense.receipt, let uiImage = UIImage(data: receipt) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .navigationTitle(expense.name)
        .toolbar {
            Button {
                currencyChange.currency = currencyChange.currency == .dollor ? .euro : .dollor
                UserDefaults.standard.set(currencyChange.currency.currencyString, forKey: K.currency)
            } label: {
                if currencyChange.currency == .dollor {
                    Image(systemName: K.dollarsign)
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: K.eurosign)
                        .foregroundColor(.blue)
                }
            }
        }

    }
}
