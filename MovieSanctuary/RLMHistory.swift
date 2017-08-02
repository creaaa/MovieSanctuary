
import Foundation
import RealmSwift

final class IntObject: Object {
    
    dynamic var id = 0
    
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
}

final class RLMHistory: Object {
    let history = List<IntObject>()
}
