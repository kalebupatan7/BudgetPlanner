//
//  PeoplesListView.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/17/23.
//

import SwiftUI
import SwiftData

struct PeoplesListView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [SortDescriptor(\People.dateAdded)]) var peoples: [People]
    
    var body: some View {
        List {
            ForEach(peoples.indices, id: \.self) { i in
                Button {
                    self.updateSelection(i)
                    dismiss()
                } label: {
                    HStack(alignment: .center) {
                        Text(peoples[i].name)
                            .font(.headline)
                            .foregroundStyle(.black)
                        Spacer()
                        if peoples[i].isSelected {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
    }
    
    func updateSelection(_ index:Int) {
        for i in 0..<peoples.count {
            peoples[i].isSelected = i == index
        }
    }
}


