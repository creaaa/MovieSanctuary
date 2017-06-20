
import UIKit

/* Nib */

protocol InstantiatableFromNib {
    static var  nibName: String { get }
    static func instantiateFromNib() -> Self
}

extension InstantiatableFromNib where Self: UIView {
    
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static func instantiateFromNib() -> Self {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
    
}

/* StoryBoard */

extension NSObjectProtocol {
    static var className: String { return String(describing: self) }
}

protocol Storyboardable: NSObjectProtocol {
    static var storyboardName: String { get }
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {
    
    static var storyboardName: String { return className }
    
    static func instantiate() -> Self {
        return UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
               .instantiateInitialViewController() as! Self
    }
    
}

/* Cell */

protocol Nibable: NSObjectProtocol {
    static var nibName: String { get }
    static var nib:     UINib  { get }
}

extension Nibable {
    
    static var nibName: String { return className }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: Bundle(for: self))
    }
    
}

extension UITableViewCell {
    static var identifier: String { return className }
}

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func register<T: UITableViewCell>(_ cellType: T.Type) where T: Nibable {
        register(T.nib, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>
        (with cellType: T.Type, for indexPath: IndexPath) -> T {
        
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
}





















