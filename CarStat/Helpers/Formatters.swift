//
//  Formatters.swift
//  CarStat
//
//  Created by Aleksey Mironov on 28.04.2022.
//

import Foundation

enum Formatters {
    static var dateApi: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    static var dateLongOutput: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    
    static var dateShortOutput: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
    
    static var nearestDeliveryDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }
    
    static var orderDateSlot: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE, dd MMMM"
        return formatter
    }
    
    static var longDateWithTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
    
    static var dayMonth: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM"
        return formatter
    }
    
    static var dateTimeWithoutTimeZone: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }
    
    static var phoneMask: String { "+X (XXX) XXX-XX-XX" }
    static var bonusCardMask: String { "XXX XXX XXX XXX" }
    static var zipCodeMask: String { "XXXXXX" }
    static var passportDepatrmentCode: String { "XXX-XXX" }
}
