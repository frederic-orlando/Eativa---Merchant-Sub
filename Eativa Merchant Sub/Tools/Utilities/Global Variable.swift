//
//  Global Variable.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 03/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

var interfaceIdiom : UIUserInterfaceIdiom {
    return UIDevice.current.userInterfaceIdiom
}

var currentDate : Date {
    let secondsOffset = TimeZone.current.secondsFromGMT()
    let modifiedDate = Calendar.current.date(byAdding: .second, value: secondsOffset, to: Date())!
    return modifiedDate
}
