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
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var conversionContainer: UIView!

    private let disposeBag = DisposeBag()

    var conversionViewController: CurrencyConversionViewController? {
        return childViewControllers.first { $0 is CurrencyConversionViewController } as? CurrencyConversionViewController
    }

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
        if let store = store {
            render(state: store.state.value)
        }
    }

    @IBAction func tappedOutsideConversionContainer(_ sender: Any) {
        view.endEditing(true)
    }
}

private extension HomeViewController {
    func render(state: ExchangeRateStore.State) {
        guard isViewLoaded else {
            return
        }

        switch state {
        case .fetching:
            render(animating: true)
        case let .fetched(rate):
            render(animating: false)
            render(rate: rate)
            updateConversionView(rate: rate)
        case let .failed(error):
            render(animating: false)
            render(error: error)
        default:
            break
        }
    }

    func render(animating: Bool) {
        if animating {
            if rate == nil {
                statusLabel.text = "Fetching exchange rate..."
                spinner.startAnimating()
                conversionViewController?.view.isHidden = true
            }
        } else {
            spinner.stopAnimating()
        }
    }

    func render(rate: ExchangeRate) {
        self.rate = rate
        statusLabel.text = "Exchange rate from \(statusDateFormatter.string(from: rate.timestamp))"
    }

    func render(error: Error) {
        guard rate == nil else {
            return
        }

        let alert = UIAlertController(title: "Oops!",
                                      message: "Could not fetch an exchange rate.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry",
                                      style: .default,
                                      handler: { (action) in
                                        self.store?.fetchExchangeRate()
        }))
        present(alert, animated: true)
    }

    func updateConversionView(rate: ExchangeRate) {
        if let conversion = conversionViewController {
            conversion.view.isHidden = false
            if let store = conversion.store {
                store.dispatch(action: .changeCurrencies(rate.currencies))
            } else {
                conversion.store = CurrencyConversionStore(settings:   CurrencyConversionUserDefaultsSettings(),
                                                           currencies: rate.currencies)
            }
        }
    }
}

extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let tapPoint = gestureRecognizer.location(in: view)
        return !conversionContainer.frame.contains(tapPoint)
    }
}
