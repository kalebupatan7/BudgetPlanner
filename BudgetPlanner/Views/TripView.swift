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
    @State private var name = ""
    @State private var email = ""
    
    
    var body: some View {
        Form {
            Section("TRIP NAME") {
                TextField("Enter Trip Name", text: $budget.name)
            }
            
            Section("TRIP DURATION") {
                DatePicker("From", selection: $budget.from, displayedComponents: [.date])
                DatePicker("To", selection: $budget.to, displayedComponents: [.date])
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
                    Image(systemName: "delete.backward.fill")
                        .renderingMode(.original)
                }
            } header: {
                Text("PEOPLE")
            } footer: {
                if peoples.count == 0 {
                    Text("Add Atleast One person To The Trip")
                        .fontWeight(.regular)
                        .foregroundStyle(.red)
                }
            }
            
            Section("ADD A PERSON") {
                List {
                    ForEach(oldPeoples.filter({$0.isSelected})) { people in
                        NavigationLink(value: people) {
                            HStack {
                                Text("Name :")
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
                    Text("Add Person")
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
                TextField("Enter Name", text: $name)
                TextField("Enter Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Button(action: {
                    if self.isValidEmailAddr(strToValidate: email) {
                        peoples.append(People(name: name, email: email, isSelected: self.oldPeoples.count == 0 && peoples.count == 0))
                        name = ""
                        email = ""
                    }
                }) {
                    Text("Add New Person")
                        .foregroundStyle(.white)
                }
                .disabled($name.wrappedValue.isEmpty || $email.wrappedValue.isEmpty)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background($name.wrappedValue.isEmpty || $email.wrappedValue.isEmpty ? .gray : .blue)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(10)
            } header: {
                Text("ADD A NEW PERSON")
            } footer: {
                if email != "" && !self.isValidEmailAddr(strToValidate: email) {
                    Text("Enter valid email address")
                        .fontWeight(.regular)
                        .foregroundStyle(.red)
                }
            }
        }
        Button(action: {
            budget.peoples = peoples
            addBudget()
            
        }) {
            Text("Add Trip")
                .foregroundStyle(.white)
        }
        .disabled(validateAllFields())
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(validateAllFields() ? .gray :.blue)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding()
        .navigationTitle("Add a Trip")
    }
    
    func addBudget() {
        modelContext.insert(budget)
        dismiss()
    }
    
    func validateAllFields() -> Bool {
        self.$budget.wrappedValue.name == "" || self.peoples.count == 0
    }
    
    func isValidEmailAddr(strToValidate: String) -> Bool {
        let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
        return emailValidationPredicate.evaluate(with: strToValidate)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Expense.self, configurations: config)
        let people = People(name: "Dummy", email: "kal@wer.com")
        let budget = Budget(name: "Dummy", from: Date(), to: Date())
        return TripView(budget: budget)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
