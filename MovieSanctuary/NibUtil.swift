
import UIKit

protocol InstantiatableFromNib {
    
    static var nibName: String { get }
    
    static func instantiateFromNib() -> Self
    
}

extension InstantiatableFromNib where Self: UIView {
    
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static func instantiateFromNib() -> Self {
        
        let nib = UINib(nibName: nibName, bundle: nil)
        
        let res = nib.instantiate(withOwner: nil, options: nil).first as! Self
        
        return res
    }
    
}
