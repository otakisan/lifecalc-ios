//
//  LifeExperience.swift
//  LifeCalc
//
//  Created by takashi on 2016/04/24.
//  Copyright © 2016年 Takashi Ikeda. All rights reserved.
//

import UIKit
import RealmSwift

class LifeExperience: Object {
    dynamic var uuid = NSUUID().UUIDString
    dynamic var createdAt = NSDate(timeIntervalSince1970: 0)
    dynamic var updatedAt = NSDate(timeIntervalSince1970: 0)
    dynamic var startsAt = NSDate()
    dynamic var endsAt = NSDate()
    dynamic var action = ""
    dynamic var place = ""
    dynamic var note = ""
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
