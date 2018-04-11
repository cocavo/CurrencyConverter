//
//  CurrencyConversionViewController.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 10/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import UIKit

final class CurrencyConversionViewController: UIViewController {
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var fromInput: UITextField!
    @IBOutlet private weak var toInput: UITextField!
    @IBOutlet private weak var fromCurrencyButton: UIButton!
    @IBOutlet private weak var toCurrencyButton: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController,
            let picker = navigation.topViewController as? CurrencyPickerViewController {
            picker.set(currencies: [
                Currency(code: "USD", rate: 1),
                Currency(code: "GBP", rate: 1),
                Currency(code: "JPY", rate: 1),
                Currency(code: "EUR", rate: 1),
                Currency(code: "RUB", rate: 1)
                ],
                       selectedCurrency: Currency(code: "RUB", rate: 1))
        }
    }
}
