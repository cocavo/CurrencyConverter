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
    func serialize(json raw: RawJSON) -> ExchangeRate? {
        let json = JSON(raw)

        guard let success = json["success"].bool, success else {
            print("'success' property is absent or false \(raw)")
            return nil
        }

        guard let ti = json["timestamp"].double else {
            print("'timestamp' property is absent \(raw)")
            return nil
        }
        let timestamp = Date(timeIntervalSince1970: ti)

        let rates: [String: Float] = (json["rates"].dictionaryObject as? [String: Float]) ?? [:]
        let currencies = rates.map { Currency(code: $0, rate: $1) }

        return ExchangeRate(timestamp: timestamp, currencies: currencies)
    }
}
