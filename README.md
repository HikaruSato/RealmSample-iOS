# RealmSample-iOS
RealmSample for iOS

I created DAO to use Realm easily!

```swift:dao
import Foundation
import RealmSwift

class RealmBaseDao <T : RealmSwift.Object> {
    let realm: Realm
    
    init() {
        try! realm = Realm()
    }
    
    /**
     * Retrieve a new id.
     */
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }
        
        if let last = realm.objects(T.self).last as? RealmSwift.Object,
            let lastId = last[key] as? Int {
            return lastId + 1
        } else {
            return 1
        }
    }
    
    /**
     * find all records.
     */
    func findAll() -> Results<T> {
        return realm.objects(T.self)
    }
    
    /**
     * Get find a first.
     */
    func findFirst() -> T? {
        return findAll().first
    }
    
    func findFirst(key: AnyObject) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }

    func findLast() -> T? {
        return findAll().last
    }
    
    func add(d :T) {
        do {
            try realm.write {
                realm.add(d)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }

    /**
    * note: Valid only when primaryKey () is implemented in RealmSwift.Object sub class.
    */
    func update(d: T, block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(d, update: true)
            }
            return true
        } catch let error as NSError {
            print(error.description)
        }
        return false
    }

    func delete(d: T) {
        do {
            try realm.write {
                realm.delete(d)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func deleteAll() {
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }

}
```

```swift:to use
class SampleObject: Object {
    
    dynamic var id = 0
    dynamic var created = NSDate()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

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
```
