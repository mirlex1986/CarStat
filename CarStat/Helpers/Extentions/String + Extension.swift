//
//  String + Extension.swift
//  CarStat
//
//  Created by Aleksey Mironov on 16.05.2022.
//

import Foundation

extension String {
    func mask(_ mask: String) -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for chur in mask where index < numbers.endIndex {
            if chur == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
                
            } else {
                result.append(chur)
            }
        }
        return result
    }
}
