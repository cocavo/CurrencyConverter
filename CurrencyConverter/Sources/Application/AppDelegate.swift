//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 10/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let fixerAPIClient: APIClient
    private let exchangeRateAPI: ExchangeRateAPI
    private let disposeBag = DisposeBag()

    override init() {
        let client = APIClient(baseURL:   "http://data.fixer.io",
                               accessKey: "435a51b385023fbdc4595d248551efd7")
        self.fixerAPIClient = client
        self.exchangeRateAPI = ExchangeRateNetworking(apiClient: client)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        exchangeRateAPI.fetchExchangeRate()
            .subscribe(onSuccess: { (rate) in
                print("Fetched rate \(rate)")
            },
                       onError: { (error) in
                        print("Fetching failed \(error)")
            })
            .disposed(by: disposeBag)

        return true
    }
}
