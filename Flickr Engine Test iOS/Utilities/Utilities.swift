//
//  Utilities.swift
//  Flickr Engine Test iOS
//
//  Created by Chee Voon on 30/04/2023.
//

import Foundation
import SwiftUI

let screen = UIScreen.main.bounds


//MARK: Functions
func printLog(_ text: String) {
    
    #if DEBUG
    let output = "\n    >>> \(text) <<<"
    print(output)
    #endif
}


//MARK: Extensions
extension Data {
    
    var prettyPrintedJSONString: NSString? {
        
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

extension Int {
    
    func toBool() -> Bool? {
        
        return (self as NSNumber).boolValue
    }
}

extension UIColor {
    
    static let normal = UIColor(named: "Normal")!
    
    static let inverted = UIColor(named: "Inverted")!
}

extension View {

    public func asUIImage() -> UIImage {
        
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asUIImage()
        
        controller.view.removeFromSuperview()
        
        return image
    }
}

extension UIView {

    public func asUIImage() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image { rendererContext in
            
            layer.render(in: rendererContext.cgContext)
        }
    }
}
