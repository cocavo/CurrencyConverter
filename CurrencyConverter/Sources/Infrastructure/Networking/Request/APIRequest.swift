//
//  APIRequest.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation

struct APIRequest {
    let path: String

    static var exchangeRate: APIRequest {
        return APIRequest(path: "/api/latest")
    }
}
