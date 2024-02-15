//
//  ExpensesPeooplesView.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/22/23.
//

import SwiftUI
import SwiftData

struct ExpensesPeooplesView: View {
    @Environment(CurrencyChange.self) private var currencyChange
    @Environment(\.dismiss) private var dismiss
    @State var peoples: [People]
    @Binding var selectedPeople: People?
    @State var checkMark:People?
    
    var body: some View {
        List(selection: $selectedPeople) {
            ForEach(peoples.indices, id: \.self) { i in
                Button {
                    selectedPeople = peoples[i]
                    dismiss()
                } label: {
                    HStack(alignment: .center) {
                        Text(peoples[i].name)
                            .font(.headline)
                            .foregroundStyle(.black)
                        Spacer()
                        if ((peoples[i].isSelected || checkMark == peoples[i]) && selectedPeople == nil)  || selectedPeople == peoples[i] {
                            Image(systemName: K.checkmarkIcon)
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
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

