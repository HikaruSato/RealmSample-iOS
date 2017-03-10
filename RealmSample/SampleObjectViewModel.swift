//
//  SampleObjectViewModel.swift
//  RealmSample
//
//  Created by 佐藤光 on 2017/03/10.
//  Copyright © 2017年 None. All rights reserved.
//

import UIKit

class SampleObjectViewModel {
    var id = 0
    var created = NSDate()
    var description:String {
        return "\(id)," + created.description
    }
    
    static let dao = RealmBaseDao<SampleObject>()
    
    init(sampleObject:SampleObject) {
        id = sampleObject.id
        created = sampleObject.created
    }
    
    static func load() -> [SampleObjectViewModel] {
        let objects = dao.findAll()
        return objects.map { SampleObjectViewModel(sampleObject: $0) }
    }
    
    static func create() -> SampleObjectViewModel {
        let object = SampleObject()
        object.id = dao.newId()!
        dao.add(d: object)
        let viewModel = SampleObjectViewModel(sampleObject:object)
        return viewModel
    }
    
    func update() {
        let dao = type(of: self).dao
        guard let object = dao.findFirst(key: id as AnyObject) else {
            return
        }
        object.created = created
        let _ = dao.update(d: object)
    }
    
    func delete() {
        let dao = type(of: self).dao
        guard let object = dao.findFirst(key: id as AnyObject) else {
            return
        }
        dao.delete(d: object)
    }
}
