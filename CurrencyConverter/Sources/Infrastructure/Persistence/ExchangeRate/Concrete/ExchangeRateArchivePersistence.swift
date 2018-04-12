//
//  ExchangeRateArchivePersistence.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation
import RxSwift

final class ExchangeRateArchivePersistence {
    private let storagePath: String
    private let serializer: ExchangeRateSerializer
    private let workingQueue: DispatchQueue

    init(storagePath: String) {
        self.storagePath = storagePath
        self.serializer = ExchangeRateSerializer()
        self.workingQueue = DispatchQueue(label: "com.persistence.exchange_rate")
        createStorageFileIfNeeded()
    }

    private func createStorageFileIfNeeded() {
        let fm = FileManager.default
        if !fm.fileExists(atPath: storagePath) {
            fm.createFile(atPath: storagePath, contents: nil)
        }
    }
}

extension ExchangeRateArchivePersistence: ExchangeRatePersistence {
    func restoreExchangeRate() -> Observable<ExchangeRate> {
        return .create { (observer) in
            self.workingQueue.async {
                var rate: ExchangeRate?
                if let json = NSKeyedUnarchiver.unarchiveObject(withFile: self.storagePath) as? RawJSON {
                    rate = self.serializer.serialize(json: json)
                }
                DispatchQueue.main.async {
                    if let rate = rate {
                        observer.onNext(rate)
                        observer.onCompleted()
                    } else {
                        observer.onError(ExchangeRatePersistenceError.noStoredExchangeRate)
                    }
                }
            }
            return Disposables.create()
        }
    }

    func storeExchangeRate(_ rate: ExchangeRate) -> Observable<ExchangeRate> {
        return .create { (observer) in
            self.workingQueue.async {
                let json = self.serializer.deserialize(entity: rate)
                NSKeyedArchiver.archiveRootObject(json, toFile: self.storagePath)
                DispatchQueue.main.async {
                    observer.onNext(rate)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
