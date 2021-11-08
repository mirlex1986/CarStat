//
//  UserMileage.swift
//  CarStat
//
//  Created by Aleksey Mironov on 20.09.2021.
//

import Foundation
import RealmSwift

class UserMileage: Object {
    @objc dynamic var date = Date()
    @objc dynamic var odometer = 0
    @objc dynamic var price = 0.0
    @objc dynamic var liters = 0.0
}
