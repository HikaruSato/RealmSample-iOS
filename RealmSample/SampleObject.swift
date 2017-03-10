//
//  SampleObject.swift
//  RealmSample
//
//  Created by 佐藤光 on 2017/03/10.
//  Copyright © 2017年 None. All rights reserved.
//

import Foundation
import RealmSwift

class SampleObject: Object {
    
    dynamic var id = 0
    dynamic var created = NSDate()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
