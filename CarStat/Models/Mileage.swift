import Foundation

struct Mileage {
    var date: Date
    var odometer: Int
    var type: RecordType.RawValue
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

enum RecordType: String {
    case refueling = "Топливо"
    case mileage = "Пробег"
    case service = "Ремонт"
}
