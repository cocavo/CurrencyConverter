//
//  Serialization.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation

typealias RawJSON = [String: Any]

protocol Serialization {
    associatedtype Entity
    func serialize(json raw: RawJSON) -> Entity?
    func deserialize(entity: Entity) -> RawJSON
}
