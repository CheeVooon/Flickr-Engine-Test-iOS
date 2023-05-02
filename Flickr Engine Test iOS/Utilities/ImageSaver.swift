//
//  ImageSaver.swift
//  Flickr Engine Test iOS
//
//  Created by Chee Voon on 02/05/2023.
//

import Foundation
import SwiftUI

class ImageSaver: NSObject {
    
    func saveToPhotoLibrary(image: UIImage) {
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
