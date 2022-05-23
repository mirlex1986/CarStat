//
//  Images.swift
//  CarStat
//
//  Created by Aleksey Mironov on 17.05.2022.
//

import UIKit

enum Images {
    static var service: UIImage { UIImage(named: "service")?.withRenderingMode(.alwaysTemplate) ?? UIImage() }
    static var fuel: UIImage { UIImage(named: "fuel")?.withRenderingMode(.alwaysTemplate) ?? UIImage() }
    static var odometer: UIImage { UIImage(named: "odometer")?.withRenderingMode(.alwaysTemplate) ?? UIImage() }
}
