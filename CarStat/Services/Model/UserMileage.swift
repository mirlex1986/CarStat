//
//  UserMileage.swift
//  CarStat
//
//  Created by Aleksey Mironov on 20.09.2021.
//

import Foundation
import RealmSwift

@objcMembers
class UserMileage: Object {
    public dynamic var date = Date()
    public dynamic var odometer = 0
    public dynamic var refueling: LocalRefueling?
    
    var data: Mileage {
        let mileage = Mileage(date: date,
                              odometer: odometer,
                              refueling: refueling?.refueling ?? Refueling(price: 0, quantity: 0, totalPrice: 0))
        return mileage
    }
}

@objcMembers
class LocalRefueling: Object {
    public dynamic var price: Double = 0.0
    public dynamic var quantity: Double = 0.0
    public dynamic var totalPrice: Double = 0.0
    
    var refueling: Refueling {
        let ref = Refueling(price: price,
                            quantity: quantity,
                            totalPrice: totalPrice)
        
        return ref
    }
}
