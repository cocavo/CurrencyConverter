//
//  ExchangeRateAPI.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation
import Alamofire

protocol ExchangeRateAPI {
    func fetchExchangeRate(completion: @escaping (Result<ExchangeRate>) -> Void)
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
    func fetchExchangeRate(completion: @escaping (Result<ExchangeRate>) -> Void) {
        apiClient.execute(request:    .exchangeRate,
                          serializer: serializer,
                          completion: completion)
    }
}
