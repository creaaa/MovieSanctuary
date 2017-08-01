
import UIKit

// 10ずつとか、ほんのわずかでも、文章見切れてしまう。。。ちょっとなー...
// 余白をaddしつつ文章途切れない方法、知らないですかねー。。
class OverviewLabel: UILabel {

    // paddingをあんまりかけすぎると、文章が途中でしれっとなくなる(auto sizingなlabelであることには変わりないが)
    @IBInspectable var padding: UIEdgeInsets =
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override func drawText(in rect: CGRect) {
        let newRect = UIEdgeInsetsInsetRect(rect, padding)
        super.drawText(in: newRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top  + padding.bottom
        contentSize.width  += padding.left + padding.right
        return contentSize
    }
    
}
