//
//  CurrencyConversionViewController.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 10/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import UIKit
import RxSwift

final class CurrencyConversionViewController: UIViewController {
    @IBOutlet private weak var fromInput: UITextField!
    @IBOutlet private weak var toInput: UITextField!
    @IBOutlet private weak var fromCurrencyButton: UIButton!
    @IBOutlet private weak var toCurrencyButton: UIButton!

    private let disposeBag = DisposeBag()

    private lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfUp
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = " "
        return formatter
    }()

    var store: CurrencyConversionStore? {
        didSet {
            store?.state
                .asObservable()
                .subscribe(onNext: { [weak self] (state) in
                    guard let this = self else { return }
                    this.render(state: state)
                })
                .disposed(by: disposeBag)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let state = store?.state.value {
            render(state: state)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let store = store, let navigation = segue.destination as? UINavigationController,
            let picker = navigation.topViewController as? CurrencyPickerViewController {
            switch segue.identifier {
            case "pickFromCurrency"?:
                picker.set(currencies:       store.state.value.currencies,
                           selectedCurrency: store.state.value.fromCurrency)
                picker.onSelectCurrencyHandler = { [weak self] (currency) in
                    guard let this = self else { return }
                    this.store?.dispatch(action: .changeFromCurrency(currency))
                }
            case "pickToCurrency"?:
                picker.set(currencies:       store.state.value.currencies,
                           selectedCurrency: store.state.value.toCurrency)
                picker.onSelectCurrencyHandler = { [weak self] (currency) in
                    guard let this = self else { return }
                    this.store?.dispatch(action: .changeToCurrency(currency))
                }
            default:
                break
            }
        }
    }
}

private extension CurrencyConversionViewController {
    func render(state: CurrencyConversionStore.State) {
        guard isViewLoaded else {
            return
        }

        fromInput.text = state.fromValue > 0 ? currencyFormatter.string(from: NSNumber(value: state.fromValue)) : ""
        fromCurrencyButton.setTitle(state.fromCurrency.code, for: .normal)
        toInput.text = state.toValue > 0 ? currencyFormatter.string(from: NSNumber(value: state.toValue)) : ""
        toCurrencyButton.setTitle(state.toCurrency.code, for: .normal)
    }
}

extension CurrencyConversionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let enteredText = ((textField.text ?? "") as NSString)
            .replacingCharacters(in: range, with: string)
            .replacingOccurrences(of: currencyFormatter.groupingSeparator, with: "")

        if enteredText.isEmpty {
            textField.text = enteredText
            handleTextChanged(in: textField, enteredValue: 0)
        } else {
            if let number = currencyFormatter.number(from: enteredText) {
                textField.text = currencyFormatter.string(from: number)
                handleTextChanged(in: textField, enteredValue: number.floatValue)
            }
        }

        return false
    }

    private func handleTextChanged(in input: UITextField, enteredValue: Float) {
        if input === fromInput {
            store?.dispatch(action: .changeFromValue(enteredValue))
        } else if input === toInput {
            store?.dispatch(action: .changeToValue(enteredValue))
        }
    }
}
