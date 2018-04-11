//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 10/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let fixerAPIClient: APIClient
    private let exchangeRateAPI: ExchangeRateAPI

    override init() {
        let client = APIClient(baseURL:   "http://data.fixer.io",
                               accessKey: "435a51b385023fbdc4595d248551efd7")
        self.fixerAPIClient = client
        self.exchangeRateAPI = ExchangeRateNetworking(apiClient: client)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        exchangeRateAPI.fetchExchangeRate { (result) in
            switch result {
            case let .success(rate):
                print("Fetched exchange rate: \(rate)")
            case let .failure(error):
                print("Fetching failed \(error)")
            }
        }

        return true
    }
}
