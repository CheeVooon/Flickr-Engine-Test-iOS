//
//  HeroView.swift
//  Flickr Engine Test iOS
//
//  Created by Chee Voon on 02/05/2023.
//

import SwiftUI

struct HeroView: View {
    
    var photo: Photo
    
    @Binding var showHero: Bool
    
    @State var image: UIImage?
    
    @State var showNotice: Bool = false
    
    var heroViewNamespace: Namespace.ID
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Color(.inverted)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 16) {
                
                self.topBarView
                
                ZStack(alignment: .center) {
                    
                    AsyncImage(url: URL(string: self.photo.urlMedia ?? "")) { imagePhase in
                        
                        switch imagePhase {
                            
                        case .empty:
                            
                            ProgressView()
                                .foregroundColor(.gray)
                            
                        case .success(let image):
                            
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .onAppear {
                                    
                                    let uiImage = image.asUIImage()
                                    
                                    self.image = uiImage
                                }
                            
                        case .failure(_):
                            
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.gray)
                            
                        @unknown default:
                            
                            ProgressView()
                                .foregroundColor(.gray)
                        }
                    }
                }
                .matchedGeometryEffect(id: self.photo.id, in: self.heroViewNamespace, properties: .position, anchor: .center)
            }
            .alert(isPresented: self.$showNotice) {
                
                Alert(title: Text("Done"), message: Text("Photo saved to album."), dismissButton: .default(Text("Dismiss")))
            }
        }
    }
    
    // Top Bar
    var topBarView: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Button(action: {
                
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()

                withAnimation(.spring()) {
                    
                    self.showHero = false
                }
                
            }, label: {
                
                Text("Back")
                    .fontWeight(.medium)
            })
            
            Spacer()
            
            Text(self.photo.title ?? "")
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                
                self.handleSavePhoto()
                
            }, label: {
                
                Text("Save")
                    .fontWeight(.medium)
            })
        }
        .padding()
        .background(Color(.systemGray4))
    }
    
    func handleSavePhoto() {
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        guard let image = self.image else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.saveToPhotoLibrary(image: image)
        
        self.showNotice.toggle()
    }
}

//struct HeroView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        HeroView()
//    }
//}
