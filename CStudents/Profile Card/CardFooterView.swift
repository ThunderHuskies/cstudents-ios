///
/// MIT License
///
/// Copyright (c) 2020 Mac Gallagher
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///

import UIKit

class CardFooterView: UIView {

    private var label = UILabel()

    private var gradientLayer: CAGradientLayer?

    init(withTitle title: String?, subtitle: String?, body: String?) {
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10
        clipsToBounds = true
        isOpaque = false
        initialize(title: title, subtitle: subtitle, body: body)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    private func initialize(title: String?, subtitle: String?, body: String?) {
        let attributedText = NSMutableAttributedString(string: (title ?? "") + "\n",
                                                       attributes: NSAttributedString.Key.titleAttributes)
        if let subtitle = subtitle, !subtitle.isEmpty {
            attributedText.append(NSMutableAttributedString(string: subtitle + "\n",
                                                              attributes: NSAttributedString.Key.subtitleAttributes))
        }
        
        if let body = body, !body.isEmpty {
            attributedText.append(NSAttributedString(string: body, attributes: NSAttributedString.Key.bodyAttributes))
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.lineBreakMode = .byTruncatingTail
        attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                     range: NSRange(location: 0, length: attributedText.length))
        label.numberOfLines = 0

        label.attributedText = attributedText
        addSubview(label)
    }

    override func layoutSubviews() {
        let padding: CGFloat = 20
        label.frame = CGRect(x: padding,
                             y: bounds.height - 130 - padding,
                             width: bounds.width - 2 * padding,
                             height: 130)
    }
}

extension NSAttributedString.Key {

    static var shadowAttribute: NSShadow = {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 2
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.3)
        return shadow
    }()

    static var titleAttributes: [NSAttributedString.Key: Any] = [
        // swiftlint:disable:next force_unwrapping
        NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 30)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]

    static var subtitleAttributes: [NSAttributedString.Key: Any] = [
        // swiftlint:disable:next force_unwrapping
        NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 20)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
    
    static var bodyAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 13)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
    ]
}
