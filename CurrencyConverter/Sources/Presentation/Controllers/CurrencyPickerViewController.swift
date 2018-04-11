//
//  CurrencyPickerViewController.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 10/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import UIKit

final class CurrencyPickerViewController: UITableViewController {
    private struct Constants {
        static let cellReuseID = "CurrencyCell"
    }

    private var currencies: [Currency] = []
    private var selectedCurrency: Currency?

    var onSelectCurrencyHandler: ((Currency) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    func set(currencies: [Currency], selectedCurrency: Currency) {
        self.currencies = currencies
        self.selectedCurrency = selectedCurrency
        if isViewLoaded {
            tableView.reloadData()
        }
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension CurrencyPickerViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configure(cell: tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseID, for: indexPath),
                         with: currencies[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectCurrencyHandler?(currencies[indexPath.row])
        dismiss(animated: true)
    }

    private func configure(cell: UITableViewCell, with currency: Currency) -> UITableViewCell {
        cell.textLabel?.text = currency.code
        cell.accessoryType = currency == selectedCurrency ? .checkmark : .none
        return cell
    }
}
