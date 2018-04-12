//
//  ExchangeRateSerializer.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation
import SwiftyJSON

final class ExchangeRateSerializer: Serialization {
    private struct JSONKeys {
        static let success   = "success"
        static let timestamp = "timestamp"
        static let rates     = "rates"
    }

    func serialize(json raw: RawJSON) -> ExchangeRate? {
        let json = JSON(raw)

        guard let success = json[JSONKeys.success].bool, success else {
            print("'\(JSONKeys.success)' property is absent or false \(raw)")
            return nil
        }

        guard let ti = json[JSONKeys.timestamp].double else {
            print("'\(JSONKeys.timestamp)' property is absent \(raw)")
            return nil
        }
        let timestamp = Date(timeIntervalSince1970: ti)

        let rates: [String: Float] = (json[JSONKeys.rates].dictionaryObject as? [String: Float]) ?? [:]
        let currencies = rates.map { Currency(code: $0, rate: $1) }

        return ExchangeRate(timestamp: timestamp, currencies: currencies)
    }

    func deserialize(entity: ExchangeRate) -> RawJSON {
        return [
            JSONKeys.success:   true,
            JSONKeys.timestamp: entity.timestamp.timeIntervalSince1970,
            JSONKeys.rates:     entity.currencies.reduce(into: RawJSON()) { (result, currency) in
                result[currency.code] = currency.rate
            }
        ]
    }
}
