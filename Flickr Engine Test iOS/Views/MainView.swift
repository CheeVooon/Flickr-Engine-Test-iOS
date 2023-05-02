//
//  MainView.swift
//  Flickr Engine Test iOS
//
//  Created by Chee Voon on 30/04/2023.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State var searchText: String = "Electrolux"
    @State var isSearching: Bool = true
    
    @State var heroPhoto: Photo?
    @State var showHero: Bool = false
    
    @State var selectorMode: Bool = false
    @State var selectedPhoto: Photo?
    
    @State var image: UIImage?
    @State var showNotice: Bool = false
    
    @State private var columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    @Namespace var heroViewNamespace
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack(alignment: .center, spacing: 0) {
                
                self.topBarView
                
                self.searchBarView
                
                self.contentView
            }
            .alert(isPresented: self.$showNotice) {
                
                Alert(title: Text("Done"), message: Text("Photo saved to album."), dismissButton: .default(Text("Dismiss")))
            }
        }
        .overlay {
            
            if let heroPhoto, self.showHero {
                
                HeroView(photo: heroPhoto, showHero: self.$showHero, heroViewNamespace: self.heroViewNamespace)
            }
        }
        .onAppear {
            
            self.handleInit()
        }
    }
    
    // Top Bar
    var topBarView: some View {
        
        ZStack(alignment: .center) {
            
            HStack(alignment: .center, spacing: 0) {
                
                if self.selectorMode {
                    
                    Button(action: {
                        
                        self.handleDisableSelector()
                        
                    }, label: {
                        
                        Text("Cancel")
                            .fontWeight(.medium)
                    })
                }
                
                Spacer()
                
                if self.selectorMode {
                    
                    Button(action: {
                        
                        self.handleSavePhoto()
                        
                    }, label: {
                        
                        Text("Save")
                            .fontWeight(.medium)
                    })
                }
            }
            
            Text("Flickr Photos")
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(.systemGray4))
    }
    
    // Search Bar
    var searchBarView: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            HStack(alignment: .center, spacing: 8) {
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(.systemGray2))
                
                TextField("Search", text: self.$searchText)
                    .keyboardType(.webSearch)
                    .autocorrectionDisabled()
                    .onSubmit {
                        
                        self.handleSearch()
                    }
                
                if self.searchText != "" {
                    
                    Button(action: {
                        
                        self.handleCancelSearch()
                        
                    }, label: {
                        
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(.systemGray2))
                    })
                }
            }
            .padding(8)
            .background(Color(.inverted))
            .cornerRadius(8)
            .padding()
            
            if self.isSearching {
                
                Button(action: {
                    
                    self.handleCancelSearch()
                    
                }, label: {
                    
                    Text("Cancel")
                        .fontWeight(.medium)
                        .padding(.trailing)
                })
            }
            
            else {
                
                Button(action: {
                    
                    self.handleSearch()
                    
                }, label: {
                    
                    Text("Search")
                        .fontWeight(.medium)
                        .padding(.trailing)
                })
            }
        }
        .background(Color(.systemGray5))
    }
    
    // Content
    var contentView: some View {
        
        ScrollView(showsIndicators: true) {
            
            Spacer(minLength: 16)
            
            if isSearching {
                
                if viewModel.photos.isEmpty {
                    
                    // Loading View
                    if viewModel.isFetching {
                        
                        ProgressView()
                    }
                    
                    // No Records
                    else {
                        
                        Text("No records")
                            .fontWeight(.medium)
                    }
                }
                
                else {
                    
                    LazyVGrid(columns: self.columns, alignment: .center, spacing: 16) {
                        
                        ForEach(viewModel.photos) { photo in
                            
                            ZStack(alignment: .topTrailing) {
                                
                                self.SmallImageView(photo)
                                    .onAppear {
                                        
                                        viewModel.getMorePhotos(currentPhoto: photo, keyword: self.searchText)
                                    }
                                    .onTapGesture {
                                        
                                        if self.selectorMode {
                                            
                                            self.handleSelectPhoto(photo: photo)
                                        }
                                        
                                        else {
                                            
                                            self.handleShowHero(photo: photo)
                                        }
                                    }
                                    .onLongPressGesture(minimumDuration: 0.6) {
                                        
                                        self.handleEnableSelector(photo: photo)
                                    }
                                
                                if self.selectedPhoto?.id == photo.id {
                                    
                                    ZStack(alignment: .center) {
                                        
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 24, height: 24)
                                    .background(Color(.systemBlue))
                                    .clipShape(Circle())
                                    .padding(8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            else {
                
                Text("Search for hashtags")
                    .fontWeight(.medium)
            }
        }
    }
    
    @ViewBuilder
    func SmallImageView(_ photo: Photo) -> some View {
        
        let width = (screen.width / 3) - 24
        
        ZStack(alignment: .center) {
            
            if !(self.showHero && self.heroPhoto?.id == photo.id) {
                
                AsyncImage(url: URL(string: photo.urlMedia ?? "")) { imagePhase in
                    
                    switch imagePhase {
                        
                    case .empty:
                        
                        ProgressView()
                            .foregroundColor(.gray)
                        
                    case .success(let image):
                        
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .onChange(of: self.selectedPhoto?.id) { id in
                                
                                if id == photo.id {
                                    
                                    let uiImage = image.asUIImage()
                                    
                                    self.image = uiImage
                                }
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
        }
        .frame(width: width, height: width)
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        .matchedGeometryEffect(id: photo.id, in: self.heroViewNamespace, properties: .position, anchor: .center)
    }
    
    func handleInit() {
        
        viewModel.getFlickrPhotos(keyword: self.searchText)
    }
    
    func handleSearch() {
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        viewModel.hideKeyboard()
        self.isSearching = true
        
        viewModel.clearPhotos()
        viewModel.getFlickrPhotos(keyword: self.searchText)
    }
    
    func handleCancelSearch() {
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        viewModel.hideKeyboard()
        self.isSearching = false
        
        self.searchText.removeAll()
        viewModel.clearPhotos()
        
        self.handleDisableSelector()
    }
    
    func handleShowHero(photo: Photo) {

        UIImpactFeedbackGenerator(style: .soft).impactOccurred()

        withAnimation(.spring()) {
            
            self.heroPhoto = photo
            self.showHero = true
        }
    }
    
    func handleEnableSelector(photo: Photo) {
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        self.selectorMode = true
        self.selectedPhoto = photo
    }
    
    func handleDisableSelector() {
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        self.selectorMode = false
        self.selectedPhoto = nil
    }
    
    func handleSelectPhoto(photo: Photo) {
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        self.selectedPhoto = photo
    }
    
    func handleSavePhoto() {
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        guard let image = self.image else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.saveToPhotoLibrary(image: image)
        
        self.showNotice.toggle()
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MainView()
    }
}
