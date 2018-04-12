//
//  ExchangeRateStore.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation
import RxSwift

final class ExchangeRateStore {
    enum State {
        case idle
        case fetching
        case fetched(ExchangeRate)
        case failed(Error)

        var isNotFetching: Bool {
            if case .fetching = self {
                return false
            }
            return true
        }
    }

    private let API: ExchangeRateAPI
    private let persistence: ExchangeRatePersistence
    private let disposeBag: DisposeBag
    let state: Variable<State>

    private var appStateObserver: NSObjectProtocol?

    init(API: ExchangeRateAPI, persistence: ExchangeRatePersistence) {
        self.API = API
        self.persistence = persistence
        self.disposeBag = DisposeBag()
        self.state = Variable(.idle)
        startAppStateObserving()
    }
}

extension ExchangeRateStore {
    func fetchExchangeRate() {
        guard state.value.isNotFetching else {
            return
        }

        Observable.concat(persistence.restoreExchangeRate().catchErrorJustComplete(),
                          fetchExchangeRateFromNetwork())
            .track(state)
            .disposed(by: disposeBag)
    }

    private func fetchExchangeRateFromNetwork() -> Observable<ExchangeRate> {
        return API.fetchExchangeRate().flatMap {
            self.persistence.storeExchangeRate($0)
        }
    }
}

private extension ExchangeRateStore {
    func startAppStateObserving() {
        let nc = NotificationCenter.default
        appStateObserver = nc.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground,
                                          object: nil,
                                          queue: .main,
                                          using: { [weak self] (_) in
                                            guard let this = self else { return }
                                            this.fetchExchangeRate()
        })
    }
}

extension Observable where Element == ExchangeRate {
    func track(_ state: Variable<ExchangeRateStore.State>) -> Disposable {
        state.value = .fetching
        return subscribe { (event) in
            switch event {
            case let .next(rate):
                state.value = .fetched(rate)
            case let .error(error):
                state.value = .failed(error)
            default:
                break
            }
        }
    }
}

extension Observable {
    func catchErrorJustComplete() -> Observable {
        return catchError { (_) in .empty() }
    }
}
