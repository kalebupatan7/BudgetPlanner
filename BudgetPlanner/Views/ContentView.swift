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
                NavigationLink(destination: TripView(budget: Budget())) { Image(systemName: "plus")
                        .foregroundColor(.black)
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

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
