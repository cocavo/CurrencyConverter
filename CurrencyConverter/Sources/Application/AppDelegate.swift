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
    private let exchangeRateStore: ExchangeRateStore

    override init() {
        let client = APIClient(baseURL:   "http://data.fixer.io",
                               accessKey: "435a51b385023fbdc4595d248551efd7")
        let API = ExchangeRateNetworking(apiClient: client)
        let cachesDirPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let persistence = ExchangeRateArchivePersistence(storagePath: cachesDirPath + "/ExchangeRate")
        self.exchangeRateStore = ExchangeRateStore(API: API, persistence: persistence)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let home = window?.rootViewController as? HomeViewController {
            home.store = exchangeRateStore
        }
        return true
    }
}
