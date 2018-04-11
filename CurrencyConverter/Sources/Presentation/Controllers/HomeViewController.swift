//
//  HomeViewController.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var loadingView: UIView!

    private let disposeBag = DisposeBag()

    private lazy var statusDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM d HH:mm"
        return formatter
    }()

    var store: ExchangeRateStore? {
        didSet {
            store?.state
                .asObservable()
                .subscribe(onNext: { [weak self] (state) in
                    guard let this = self else { return }
                    this.render(state: state)
                })
                .disposed(by: disposeBag)
            store?.fetchExchangeRate()
        }
    }

    var rate: ExchangeRate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubview(toFront: loadingView)
        if let store = store {
            render(state: store.state.value)
        }
    }
}

private extension HomeViewController {
    func render(state: ExchangeRateStoreState) {
        guard isViewLoaded else {
            return
        }

        switch state {
        case .fetching:
            if rate == nil {
                loadingView.isHidden = false
            }
        case let .fetched(rate):
            self.rate = rate
            loadingView.isHidden = true
            render(rate: rate)
        case let .failed(error):
            render(error: error)
        default:
            break
        }
    }

    func render(rate: ExchangeRate) {
        statusLabel.text = "Exchange rate from \(statusDateFormatter.string(from: rate.timestamp))"
    }

    func render(error: Error) {
        let alert = UIAlertController(title: "Oops!",
                                      message: "Could not fetch an exchange rate",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry",
                                      style: .default,
                                      handler: { (action) in
                                        self.store?.fetchExchangeRate()
        }))
        present(alert, animated: true)
    }
}
