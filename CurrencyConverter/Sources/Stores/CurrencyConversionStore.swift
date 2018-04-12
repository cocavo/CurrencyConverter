//
//  CurrencyConversionStore.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 12/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation
import RxSwift

final class CurrencyConversionStore {
    struct State {
        fileprivate(set) var currencies: [Currency]
        fileprivate(set) var fromCurrency: Currency
        fileprivate(set) var fromValue: Float
        fileprivate(set) var toCurrency: Currency
        fileprivate(set) var toValue: Float
    }

    enum Action {
        case changeCurrencies([Currency])
        case changeFromCurrency(Currency)
        case changeFromValue(Float)
        case changeToCurrency(Currency)
        case changeToValue(Float)
    }

    private let settings: CurrencyConversionSettings
    var state: Variable<State>!

    init?(settings: CurrencyConversionSettings, currencies: [Currency]) {
        guard CurrencyConversionStore.isEnoughCurrencies(currencies) else {
            return nil
        }
        self.settings = settings
        self.state = Variable(buildInitialState(for: currencies))
    }
}

extension CurrencyConversionStore {
    func dispatch(action: Action) {
        var state = self.state.value

        switch action {

        case let .changeCurrencies(currencies):
            if CurrencyConversionStore.isEnoughCurrencies(currencies) {
                state.currencies = currencies
                state.fromCurrency = obtainFromCurrency(from: currencies)
                state.toCurrency = obtainToCurrency(from: currencies)
                state.toValue = recalculateToValue(for: state)
            }

        case let .changeFromCurrency(currency):
            state.fromCurrency = currency
            settings.fromCurrencyCode = currency.code
            state.toValue = recalculateToValue(for: state)

        case let .changeFromValue(value):
            state.fromValue = value
            state.toValue = recalculateToValue(for: state)

        case let .changeToCurrency(currency):
            state.toCurrency = currency
            settings.toCurrencyCode = currency.code
            state.fromValue = recalculateFromValue(for: state)

        case let .changeToValue(value):
            state.toValue = value
            state.fromValue = recalculateFromValue(for: state)
        }
        
        self.state.value = state
    }

    private func recalculateFromValue(for state: State) -> Float {
        return convert(value: state.toValue,
                       from:  state.toCurrency,
                       to:    state.fromCurrency)
    }

    private func recalculateToValue(for state: State) -> Float {
        return convert(value: state.fromValue,
                       from:  state.fromCurrency,
                       to:    state.toCurrency)
    }

    private func convert(value: Float, from: Currency, to: Currency) -> Float {
        return (value / from.rate) * to.rate
    }
}

private extension CurrencyConversionStore {
    class func isEnoughCurrencies(_ currencies: [Currency]) -> Bool {
        return currencies.count > 2
    }

    func buildInitialState(for currencies: [Currency]) -> State {
        return State(currencies:   currencies,
                     fromCurrency: obtainFromCurrency(from: currencies),
                     fromValue:    0,
                     toCurrency:   obtainToCurrency(from: currencies),
                     toValue:      0)
    }

    func obtainFromCurrency(from currencies: [Currency]) -> Currency {
        if let code = settings.fromCurrencyCode {
            return currencies.first { $0.code == code } ?? currencies[0]
        }
        return currencies.first { $0.code == "USD" } ?? currencies[0]
    }

    func obtainToCurrency(from currencies: [Currency]) -> Currency {
        if let code = settings.toCurrencyCode {
            return currencies.first { $0.code == code } ?? currencies[1]
        }
        return currencies.first { $0.code == "RUB" } ?? currencies[1]
    }
}
