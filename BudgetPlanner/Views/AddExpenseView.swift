//
//  AddExpenseView.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/22/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddExpenseView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(CurrencyChange.self) private var currencyChange
    @Bindable var budget: Budget
    @State private var expense = Expense()
    @State private var selectedPeople: People?
    @State private var isCustomEnabled: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @FocusState private var focusedField: Field?
    private enum Field: Int, CaseIterable {
        case amount
        case str
    }
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    var body: some View {
        NavigationStack {
            Form {
                Section("EXPENSE NAME") {
                    TextField("Enter Trip Name", text: $expense.name)
                        .focused($focusedField, equals: .str)
                }
                
                Section("PAID BY") {
                    List {
                        let selectedPeople = selectedPeople == nil ? ($budget.wrappedValue.peoples.filter({$0.isSelected}).first == nil ? $budget.wrappedValue.peoples.first : $budget.wrappedValue.peoples.filter({$0.isSelected}).first) : selectedPeople
                        if let selectedPeople = selectedPeople {
                            ForEach([selectedPeople]) { people in
                                NavigationLink(destination: ExpensesPeooplesView(peoples: $budget.wrappedValue.peoples, selectedPeople: $selectedPeople)) {
                                    HStack {
                                        Text("Paid By")
                                        Spacer()
                                        Text(people.name)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
                Section {
                    TextField("Enter Expense Amount", value: $expense.amount, format: .currency(code: currencyChange.currency.rawValue))
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .amount)

                } header: {
                    Text("EXPENSE AMOUNT")
                }
                
                Section("CUSTOM SPLIT") {
                    Toggle(isOn: $isCustomEnabled) {
                        Text("EXPENSE AMOUNT")
                    }
                    if isCustomEnabled {
                        ForEach($budget.wrappedValue.peoples) { people in
                            HStack {
                                Text("\(people.name) :")
                                Spacer()
                                ChangeValue(people: people)
                                    .focused($focusedField, equals: .amount)
                            }
                        }
                        if validateExactMatch() {
                            Text("The Split does not Cover the Entire Expense")
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        } else if let uiImage = UIImage(systemName: "photo") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        }
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                Text("Add Picture")
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(.blue)
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .circular))
                            .navigationTitle("Add a Trip")
                            .onChange(of: selectedItem) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        self.selectedImageData = data
                                    }
                                }
                            }
                    }
                }
                
            }
            .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        if focusedField == .amount {
                            HStack {
                                Spacer()
                                Button("Done") {
                                    focusedField = nil
                                }
                            }
                        }
                    }
                }
            Button(action: {
                 selectedPeople = selectedPeople == nil ? ($budget.wrappedValue.peoples.filter({$0.isSelected}).first == nil ? $budget.wrappedValue.peoples.first : $budget.wrappedValue.peoples.filter({$0.isSelected}).first) : selectedPeople
                if !isCustomEnabled {
                    selectedPeople?.settled = expense.amount
                }
                if let selectedPeople = selectedPeople {
                    expense.paidBy = PeopleWithMoney(people: selectedPeople,settled: selectedPeople.settled)
                }
                var newShares = [PeopleWithMoney]()
                for people in $budget.wrappedValue.peoples {
                    if people == selectedPeople {
                        newShares.append(expense.paidBy!)
                    } else {
                        newShares.append(PeopleWithMoney(people: people, settled: people.settled))
                    }
                }
                if isCustomEnabled {
                    expense.shares = newShares
                }
                $budget.wrappedValue.peoples.forEach {  $0.settled = nil}
                expense.receipt = selectedImageData
                addExpense()
            }) {
                Text("Add Trip")
                    .foregroundStyle(.white)
            }
            .disabled(validateAllFields())
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(validateAllFields() ? .gray :.blue)
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .circular))
        }
        .navigationTitle("Add a Trip")
    }
    
    func addExpense() {
        budget.expenses.append(expense)
        dismiss()
    }
    
    func isValidAmount() -> Bool {
        return true
    }
    
    func validateAllFields() -> Bool {
        self.$expense.wrappedValue.name == "" || self.$expense.wrappedValue.amount == 0 || isCustomEnabled && ($budget.wrappedValue.peoples.compactMap({$0.settled}).count == 0 || validateExactMatch())
    }
    
    func validateExactMatch() -> Bool {
        let values = $budget.wrappedValue.peoples.compactMap({$0.settled})
        if values.count == 0 {
            return false
        }
        return expense.amount != values.reduce(0,+)
    }
}

struct ChangeValue: View {
    
    let people: People
    
    @State private var questionVariable = ""
    
    var body: some View {
        
        TextField("$$", text: $questionVariable)
            .multilineTextAlignment(.trailing)
            .keyboardType(.decimalPad)
            .onChange(of: questionVariable) { old, new in
                if let val = Double(new) {
                    people.settled = Decimal((round(val*100000)/100000))
                } else {
                    people.settled = nil
                }
            }
    }
}
