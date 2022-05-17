//
//  Date + Extention.swift
//  CarStat
//
//  Created by Aleksey Mironov on 28.04.2022.
//

import Foundation

extension Date {
    var onlyDate: Date? {
            get {
                let calender = Calendar.current
                var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
                dateComponents.timeZone = NSTimeZone.system
                return calender.date(from: dateComponents)
            }
        }
}
