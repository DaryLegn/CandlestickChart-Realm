
import Foundation
import Realm
import RealmSwift

class DataObject: Object {
    
    @objc dynamic var open: Double = 0.0
    @objc dynamic var close: Double = 0.0
    @objc dynamic var low: Double = 0.0
    @objc dynamic var high: Double = 0.0
    @objc dynamic var time: Int64 = 0
    
}


