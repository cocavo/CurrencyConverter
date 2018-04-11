//
//  ExchangeRatePersistence.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation
import RxSwift

protocol ExchangeRatePersistence {
    func restoreExchangeRate() -> Single<ExchangeRate?>
    func storeExchangeRate(_ rate: ExchangeRate) -> Single<ExchangeRate>
}
