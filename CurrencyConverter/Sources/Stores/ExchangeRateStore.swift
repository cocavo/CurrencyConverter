//
//  ExchangeRateStore.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation
import RxSwift

enum ExchangeRateStoreState {
    case idle
    case fetching
    case fetched(ExchangeRate)
    case failed(Error)
}

extension ExchangeRateStoreState {
    var isNotFetching: Bool {
        if case .fetching = self {
            return false
        }
        return true
    }
}

final class ExchangeRateStore {
    private let API: ExchangeRateAPI
    private let persistence: ExchangeRatePersistence
    private let disposeBag: DisposeBag
    let state: Variable<ExchangeRateStoreState>

    init(API: ExchangeRateAPI, persistence: ExchangeRatePersistence) {
        self.API = API
        self.persistence = persistence
        self.disposeBag = DisposeBag()
        self.state = Variable(.idle)
    }
}

extension ExchangeRateStore {
    func fetchExchangeRate() {
        guard state.value.isNotFetching else {
            return
        }

        API.fetchExchangeRate()
            .flatMap {
                self.persistence.storeExchangeRate($0)
            }
            .track(state)
            .disposed(by: disposeBag)
    }

    private func fetchExchangeRateFromNetwork() -> Single<ExchangeRate> {
        return API.fetchExchangeRate().flatMap {
            self.persistence.storeExchangeRate($0)
        }
    }
}

extension Single where TraitType == SingleTrait, Element == ExchangeRate {
    func track(_ state: Variable<ExchangeRateStoreState>) -> Disposable {
        state.value = .fetching
        return subscribe { (event) in
            switch event {
            case let .success(rate):
                state.value = .fetched(rate)
            case let .error(error):
                state.value = .failed(error)
            }
        }
    }
}
