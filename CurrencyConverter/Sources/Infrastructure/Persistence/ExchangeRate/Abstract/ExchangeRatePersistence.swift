//
//  ExchangeRatePersistence.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation
import RxSwift

enum ExchangeRatePersistenceError: Error {
    case noStoredExchangeRate
}

protocol ExchangeRatePersistence {
    func restoreExchangeRate() -> Observable<ExchangeRate>
    func storeExchangeRate(_ rate: ExchangeRate) -> Observable<ExchangeRate>
}
