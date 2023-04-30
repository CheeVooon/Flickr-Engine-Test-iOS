//
//  Utilities.swift
//  Flickr Engine Test iOS
//
//  Created by Chee Voon on 30/04/2023.
//

import Foundation
import SwiftUI

let screen = UIScreen.main.bounds

func printLog(_ text: String) {
    
    #if DEBUG
    let output = "\n    >>> \(text) <<<"
    print(output)
    #endif
}

extension Data {
    
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        ///
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
