//
//  EditTripView.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/14/23.
//

import SwiftUI
import SwiftData

struct EditTripView: View {
    @Environment(CurrencyChange.self) private var currencyChange
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [SortDescriptor(\People.dateAdded) ]) private var oldPeoples: [People]
    @Bindable var budget: Budget
    @State private var peoples = [People]()
    @State private var name = K.emptyString
    @State private var email = K.emptyString
    
    var body: some View {
        Form {
            Section {
                ForEach($budget.wrappedValue.peoples) { people in
                    Text(people.name)
                }
                ForEach(peoples) { people in
                    Text(people.name)
                }
                if peoples.count > 0 {
                    Button(action: {
                        if peoples.count > 0 {
                            peoples.removeLast()
                        }
                    }) {
                        Image(systemName: K.deleteIcon)
                            .renderingMode(.original)
                    }
                }
            } header: {
                Text(K.people)
            }
            
            Section(K.addAPerson) {
                List {
                    ForEach(oldPeoples.filter({$0.isSelected})) { people in
                        NavigationLink(destination: PeoplesListView()) {
                            HStack {
                                Text(K.name)
                                Spacer()
                                Text(people.name)
                            }
                        }
                    }
                }
                Button(action: {
                    if let people = oldPeoples.filter({$0.isSelected}).first {
                        peoples.append(people)
                    }
                }) {
                    Text(K.addPerson)
                        .foregroundStyle(.white)
                    
                }
                .disabled(oldPeoples.count == 0)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(oldPeoples.count == 0 ? .gray : .blue)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(10)
            }
            
            
            Section {
                TextField(K.enterName, text: $name)
                TextField(K.enterEmail, text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Button(action: {
                    if self.isValidEmailAddr(strToValidate: email) {
                        peoples.append(People(name: name, email: email, isSelected: false))
                        name = K.emptyString
                        email = K.emptyString
                    }
                }) {
                    Text(K.addNewPerson)
                        .foregroundStyle(.white)
                }
                .disabled($name.wrappedValue.isEmpty || $email.wrappedValue.isEmpty)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background($name.wrappedValue.isEmpty || $email.wrappedValue.isEmpty ? .gray : .blue)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(10)
            } header: {
                Text(K.addANewPerson)
            } footer: {
                if email != K.emptyString && !self.isValidEmailAddr(strToValidate: email) {
                    Text(K.enterValidEmail)
                        .fontWeight(.regular)
                        .foregroundStyle(.red)
                }
            }
            
            Section {
                Button(action: {
                    $budget.wrappedValue.peoples.append(contentsOf: peoples)
                    $budget.wrappedValue.peoples.sort(by: {$0.dateAdded < $1.dateAdded})
                    peoples.removeAll()
                }) {
                    Text(K.confirmChanges)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(10)
            }
        }
        VStack {
            NavigationLink(destination: {
                ExpensesListView(budget: budget)
            }) {
                Text(K.expenses)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding()
            
            NavigationLink(destination: {
                SettleUpView(budget: budget)
            }) {
                Text(K.settleUp)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding()
            
        }
        .navigationTitle(budget.name)
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
    
    func validateAllFields() -> Bool {
        self.$budget.wrappedValue.name == K.emptyString || self.peoples.count == 0
    }
    
    func isValidEmailAddr(strToValidate: String) -> Bool {
        let emailValidationPredicate = NSPredicate(format: K.selfMatches, K.validEmailRegex)
          return emailValidationPredicate.evaluate(with: strToValidate)
   }

}
