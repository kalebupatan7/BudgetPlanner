//
//  Utils.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/23/23.
//

import Foundation
import SwiftUI

extension String {
    func fixToBrowserString() -> String {
        self.replacingOccurrences(of: ";", with: "%3B")
            .replacingOccurrences(of: "\n", with: "%0D%0A")
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: "!", with: "%21")
            .replacingOccurrences(of: "\"", with: "%22")
            .replacingOccurrences(of: "\\", with: "%5C")
            .replacingOccurrences(of: "/", with: "%2F")
            .replacingOccurrences(of: "‘", with: "%91")
            .replacingOccurrences(of: ",", with: "%2C")
    }
}

enum Currency: String, CaseIterable, Identifiable {
    case AUD, CAD, EUR, GBP, NZD, USD
    var id: String { self.rawValue }
}

enum Currencies: String {
    case dollor = "USD"
    case euro = "EUR"
}

@Observable class CurrencyChange: ObservableObject {
    var currency:Currencies = .dollor
    
}
