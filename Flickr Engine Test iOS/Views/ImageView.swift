//
//  ImageView.swift
//  Flickr Engine Test iOS
//
//  Created by Chee Voon on 30/04/2023.
//

import SwiftUI

struct ImageView: View {
    
    var imageURL: String
    
    var body: some View {
        
        let width = (screen.width / 3) - 24
        
        ZStack(alignment: .center) {
            
            AsyncImage(url: URL(string: self.imageURL)) { imagePhase in
                
                switch imagePhase {
                    
                case .empty:
                    
                    ProgressView()
                        .foregroundColor(.gray)
                    
                case .success(let image):
                    
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                case .failure(_):
                    
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(.gray)
                    
                @unknown default:
                    
                    ProgressView()
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: width, height: width)
        .mask(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }
}

//struct ImageView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        ImageView()
//    }
//}
