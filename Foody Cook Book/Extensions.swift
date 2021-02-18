//
//  Extensions.swift
//  Traffic Camera
//
//  Created by Arijit Das on 16/02/21.
//

import UIKit

protocol NullStripable {
    func strippingNulls() -> Self
}

extension Array: NullStripable {
    func strippingNulls() -> Self {
        return compactMap {
            switch $0 {
            case let strippable as NullStripable:
                // the forced cast here is necessary as the compiler sees
                // `strippable` as NullStripable, as we casted it from `Element`
                return (strippable.strippingNulls() as! Element)
            case is NSNull:
                return nil
            default:
                return $0
            }
        }
    }
}

extension Dictionary: NullStripable {
    func strippingNulls() -> Self {
        return compactMapValues {
            switch $0 {
            case let strippable as NullStripable:
                // the forced cast here is necessary as the compiler sees
                // `strippable` as NullStripable, as we casted it from `Value`
                return (strippable.strippingNulls() as! Value)
            case is NSNull:
                return nil
            default:
                return $0
            }
        }
    }
    
    func allKeys() -> [String] {
      guard self.keys.first is String else {
        debugPrint("This function will not return other hashable types. (Only strings)")
        return []
      }
      return self.compactMap { (anEntry) -> String? in
                            guard let temp = anEntry.key as? String else { return nil }
                            return temp }
    }
}

extension UIViewController {
    class func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: nil)
    }
    
    func removeChild() {
        self.children.forEach {
            $0.willMove(toParent: nil)
            $0.removeFromParent()
        }
    }
    
    func showToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.image = anyImage
    }
}

extension UILabel {
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

extension Array where Element: Equatable {
    
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
}
