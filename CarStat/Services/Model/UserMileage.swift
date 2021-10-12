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
    @objc dynamic var odometer = Int()
}
