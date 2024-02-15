//
//  SettleUpView.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/23/23.
//

import SwiftUI

struct SettleUpView: View {
    
    @Environment(CurrencyChange.self) private var currencyChange
    @State var budget: Budget
    
    var body: some View {
        List {
            ForEach($budget.wrappedValue.peoples) { people in
                Section(people.name) {
                    ForEach(ownesByUser(people,$budget.wrappedValue.expenses), id: \.self) { text in
                        Text(text)
                    }
                }
            }
        }
        Button(action: {
            var body = K.tripName + K.colon + K.space + budget.name + K.newLine + K.newLine
            for people in $budget.wrappedValue.peoples {
                for val in ownesByUser(people,$budget.wrappedValue.expenses) {
                    body += val + K.newLine
                }
            }
            self.openMail(emailTo: self.$budget.wrappedValue.peoples.map({$0.email}).joined(separator: K.comma), subject: K.remainder, body: body)
        }) {
            Text(K.remindPeople)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding()
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
    
    func ownesByUser(_ user:People, _ expenses:[Expense]) -> [String] {
        
        var owes = [People:Decimal]()
        for expense in expenses {
            if let paidBy = expense.paidBy?.people, paidBy.id != user.id {
                for share in expense.shares {
                    if let sharePeople = share.people, sharePeople.id == user.id {
                        owes[paidBy, default: 0] +=  share.settled ?? 0
                    }
                }
            }
        }
        
        var final = [String]()
        
        for (k,v) in owes {
            final.append(K.owes+(k.name)+K.colon+K.space+((currencyChange.currency.getCurrencyValue * v).formatted(.currency(code: currencyChange.currency.currencyString))))
        }
        final = final.count == 0 ? [K.owesNothing] : final
        return final
    }
    
    func openMail(emailTo:String, subject: String, body: String) {
        if let url = URL(string: K.mailTo+(emailTo)+K.subject+(subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)+K.body+(body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

