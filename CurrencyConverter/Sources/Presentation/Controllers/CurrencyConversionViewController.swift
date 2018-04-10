//
//  CurrencyConversionViewController.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 10/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import UIKit

class CurrencyConversionViewController: UIViewController {

    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var fromInput: UITextField!
    @IBOutlet private weak var toInput: UITextField!
    @IBOutlet private weak var fromCurrencyButton: UIButton!
    @IBOutlet private weak var toCurrencyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
