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
    public dynamic var primaryKey = 0
    public dynamic var date = ""
    public dynamic var odometer = 0
    public dynamic var type = ""
    public dynamic var refueling: LocalRefueling?
    public dynamic var service: LocalService?
    
    var data: Mileage {
        let mileage = Mileage(date: Formatters.dateApi.date(from: date) ?? Date(),
                              odometer: odometer,
                              type: type,
                              refueling: refueling?.refueling,
                              service: service?.service)
        return mileage
    }
    
    override class func primaryKey() -> String? {
         return "primaryKey"
     }
}

@objcMembers
class LocalRefueling: Object {
    public dynamic var price = 0.0
    public dynamic var quantity = 0.0
    public dynamic var totalPrice = 0.0
    
    var refueling: Refueling {
        let ref = Refueling(price: price,
                            quantity: quantity,
                            totalPrice: totalPrice)
        
        return ref
    }
}

@objcMembers
class LocalService: Object {
    public dynamic var price = 0.0
    public dynamic var type = ""
    public dynamic var userComment = ""
    
    var service: Service {
        let service = Service(type: type)
        return service
    }
}
