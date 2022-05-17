//
//  Mileage.swift
//  CarStat
//
//  Created by Aleksey Mironov on 20.09.2021.
//

import Foundation

struct Mileage {
    var date: Date
    var odometer: Int
    var refueling: Refueling?
    var service: Service?
}

struct Refueling {
    var price: Double?
    var quantity: Double?
    var totalPrice: Double?
}

struct Service {
    var type: String
    var totalPrice: Double?
    var userComment: String?
}
