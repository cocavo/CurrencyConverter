//
//  CurrencyConversionSettings.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 12/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation

protocol CurrencyConversionSettings: class {
    var fromCurrencyCode: String? { get set }
    var toCurrencyCode: String? { get set }
}

final class CurrencyConversionUserDefaultsSettings: CurrencyConversionSettings {
    private struct Keys {
        static let fromCurrency = "fromCurrency"
        static let toCurrency   = "toCurrency"
    }

    private let ud = UserDefaults.standard

    var fromCurrencyCode: String? {
        get {
            return ud.string(forKey: Keys.fromCurrency)
        }
        set {
            ud.set(newValue, forKey: Keys.fromCurrency)
        }
    }

    var toCurrencyCode: String? {
        get {
            return ud.string(forKey: Keys.toCurrency)
        }
        set {
            ud.set(newValue, forKey: Keys.toCurrency)
        }
    }
}
