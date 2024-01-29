//
//  TripView.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/17/23.
//

import SwiftUI
import SwiftData

struct TripView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [SortDescriptor(\People.dateAdded)]) var oldPeoples: [People]
    @State var budget: Budget
    @State private var peoples = [People]()
    @State private var name = K.emptyString
    @State private var email = K.emptyString
    
    var body: some View {
        Form {
            Section(K.tripName) {
                TextField(K.enterTripname, text: $budget.name)
            }
            
            Section(K.tripDuration) {
                DatePicker(K.from, selection: $budget.from, displayedComponents: [.date])
                DatePicker(K.to, selection: $budget.to, displayedComponents: [.date])
            }
            
            Section {
                ForEach(peoples) { people in
                    Text(people.name)
                }
                Button(action: {
                    if peoples.count > 0 {
                        peoples.removeLast()
                    }
                }) {
                    Image(systemName: K.deleteIcon)
                        .renderingMode(.original)
                }
            } header: {
                Text(K.people)
            } footer: {
                if peoples.count == 0 {
                    Text(K.addAtlestOnePerson)
                        .fontWeight(.regular)
                        .foregroundStyle(.red)
                }
            }
            
            Section(K.addAPerson) {
                List {
                    ForEach(oldPeoples.filter({$0.isSelected})) { people in
                        NavigationLink(value: people) {
                            HStack {
                                Text(K.name)
                                Spacer()
                                Text(people.name)
                            }
                        }
                    }
                }
                .navigationDestination(for: People.self) { val in
                    PeoplesListView()
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
            
            Section{
                TextField(K.enterName, text: $name)
                TextField(K.enterEmail, text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Button(action: {
                    if self.isValidEmailAddr(strToValidate: email) {
                        peoples.append(People(name: name, email: email, isSelected: self.oldPeoples.count == 0 && peoples.count == 0))
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
        }
        Button(action: {
            budget.peoples = peoples
            addBudget()
            
        }) {
            Text(K.addTrip)
                .foregroundStyle(.white)
        }
        .disabled(validateAllFields())
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(validateAllFields() ? .gray :.blue)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding()
        .navigationTitle(K.addATrip)
    }
    
    func addBudget() {
        modelContext.insert(budget)
        dismiss()
    }
    
    func validateAllFields() -> Bool {
        self.$budget.wrappedValue.name == K.emptyString || self.peoples.count == 0
    }
    
    func isValidEmailAddr(strToValidate: String) -> Bool {
        let emailValidationPredicate = NSPredicate(format: K.selfMatches, K.validEmailRegex)
        return emailValidationPredicate.evaluate(with: strToValidate)
    }
}
