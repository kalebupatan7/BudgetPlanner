//
//  Utils.swift
//  BudgetPlanner
//
//  Created by Kalebu Patan on 11/23/23.
//

import Foundation
import SwiftUI

enum Currencies {
    case dollor
    case euro
    
    var getCurrencyValue: Decimal {
        switch self {
        case .dollor: return 1
        case .euro: return 0.92
        }
    }
    
    var currencyString: String {
        switch self {
        case .dollor: return K.dollor
        case .euro: return K.euro
        }
    }
    
}

@Observable class CurrencyChange: ObservableObject {
    var currency:Currencies = UserDefaults.standard.string(forKey: K.currency) == K.euro ? .euro : .dollor
}
