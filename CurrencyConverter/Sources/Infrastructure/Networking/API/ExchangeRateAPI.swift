//
//  ExchangeRateAPI.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation
import RxSwift

protocol ExchangeRateAPI {
    func fetchExchangeRate() -> Observable<ExchangeRate>
}

final class ExchangeRateNetworking {
    private let apiClient: APIClient
    private let serializer: ExchangeRateSerializer

    init(apiClient: APIClient) {
        self.apiClient = apiClient
        self.serializer = ExchangeRateSerializer()
    }
}

extension ExchangeRateNetworking: ExchangeRateAPI {
    func fetchExchangeRate() -> Observable<ExchangeRate> {
        return apiClient.execute(request:    .exchangeRate,
                                 serializer: serializer)
    }
}
