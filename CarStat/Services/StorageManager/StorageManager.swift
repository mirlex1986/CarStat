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
    
    func update(mileage: UserMileage) {
        do {
            try realm.write {
                realm.add(mileage, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(mileage: UserMileage) {
        do {
            try realm.write {
                realm.delete(mileage)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchData() -> Results<UserMileage> {
        var someObjects: [UserMileage] = []
        let sortProperties = [SortDescriptor(keyPath: "date", ascending: false), SortDescriptor(keyPath: "odometer", ascending: false)]
        let objects = realm.objects(UserMileage.self).sorted(by: sortProperties)
        
        for object in objects{
            someObjects.append(object)
        }
        return objects
    }
}
