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
            var body = "Trip Name: \(budget.name)\n\n"
            for people in $budget.wrappedValue.peoples {
                for val in ownesByUser(people,$budget.wrappedValue.expenses) {
                    body += val + "\n"
                }
            }
            self.openMail(emailTo: self.$budget.wrappedValue.peoples.map({$0.email}).joined(separator: ","), subject: "Remainder From Budgetly", body: body)
        }) {
            Text("Add Trip")
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .circular))
        
    }
    
    func ownesByUser(_ user:People, _ expenses:[Expense]) -> [String] {
        
        var owes = [People:Decimal]()
        for expense in expenses {
            if expense.paidBy?.people?.id != user.id {
                for share in expense.shares {
                    if let sharePeople = share.people, sharePeople.id == user.id {
                        owes[sharePeople, default: 0] +=  share.settled ?? 0
                    }
                }
            }
        }
        
        var final = [String]()
        
        for (k,v) in owes {
            final.append("Owes \(k.name): \(v.formatted(.currency(code: currencyChange.currency.rawValue)))")
        }
        final = final.count == 0 ? ["Owes Nothing!"] : final
        return final
    }
    
    func openMail(emailTo:String, subject: String, body: String) {
        if let url = URL(string: "mailto:\(emailTo)?subject=\(subject.fixToBrowserString())&body=\(body.fixToBrowserString())"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

