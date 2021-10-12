//
//  StorageManager.swift
//  CarStat
//
//  Created by Aleksey Mironov on 14.09.2021.
//

import Foundation
import RxSwift
import RealmSwift
import RxCocoa
import RxRealm

class StorageManager {
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    func save(mileage: UserMileage) {
        do {
            try realm.write {
                realm.add(mileage)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func fetchData() -> [UserMileage] {
//        var someObjects: [UserMileage] = []
//        let objects = realm.objects(UserMileage.self)
//
//        for object in objects{
//            someObjects.append(object)
//        }
//        return someObjects
//    }
    
    func fetchData() -> Results<UserMileage> {
        var someObjects: [UserMileage] = []
        let objects = realm.objects(UserMileage.self)
        
        for object in objects{
            someObjects.append(object)
        }
        return objects
    }
}
