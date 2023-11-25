//
//  ContentView.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/13/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(CurrencyChange.self) private var currencyChange
    @Query(sort: [SortDescriptor(\Budget.from, order: .reverse), SortDescriptor(\Budget.name)]) var budgets: [Budget]
    @State private var visibility: NavigationSplitViewVisibility = .all
    @State private var selectedBudget: Budget?
    
    var body: some View {
        
        NavigationSplitView(columnVisibility: $visibility) {
            List(selection: $selectedBudget) {
                ForEach(budgets) { budget in
                    NavigationLink(value: budget) {
                        VStack(alignment: .leading) {
                            Text(budget.name)
                                .font(.headline)
                            Text(budget.from.formatted(date: .long, time: .shortened))
                        }
                    }
                }
                .onDelete(perform: deleteDestinations)
            }
            .navigationTitle("Trips")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        currencyChange.currency = currencyChange.currency == .dollor ? .euro : .dollor
                    } label: {
                        if currencyChange.currency == .dollor {
                            Image(systemName: "dollarsign")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "eurosign")
                                .foregroundColor(.blue)
                        }
                    }

                    NavigationLink(destination: TripView(budget: Budget())) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
        } detail: {
            if let selectedBudget = selectedBudget {
                NavigationStack {
                    EditTripView(budget: selectedBudget)
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        
    }
    
    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = budgets[index]
            modelContext.delete(destination)
        }
    }
}


#Preview {
    ContentView()
}
