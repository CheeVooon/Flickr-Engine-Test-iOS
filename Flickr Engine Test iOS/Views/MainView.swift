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
    
    @State private var columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack(alignment: .center, spacing: 0) {
                
                // Top Bar
                ZStack(alignment: .center) {
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            
                            Text("Save")
                                .fontWeight(.medium)
                        })
                    }
                    
                    Text("Flickr Photos")
                        .fontWeight(.medium)
                }
                .padding()
                .background(Color(.systemGray4))
                
                // Search Bar
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
                    .background(Color(.white))
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
                
                // Contents
                ScrollView(showsIndicators: true) {
                    
                    Spacer(minLength: 16)
                    
                    if isSearching {
                        
                        if viewModel.photos.isEmpty {
                            
                            if viewModel.isFetching {
                                
                                ProgressView()
                            }
                            
                            else {
                                
                                Text("No records")
                                    .fontWeight(.medium)
                            }
                        }
                        
                        else {
                            
                            LazyVGrid(columns: self.columns, alignment: .center, spacing: 16) {
                                
                                ForEach(viewModel.photos) { photo in
                                    
                                    ImageView(imageURL: photo.urlMedia ?? "")
                                        .onAppear {
                                            
                                            viewModel.getMorePhotos(currentPhoto: photo, keyword: self.searchText)
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
        }
        .onAppear {
            
            self.handleInit()
        }
    }
    
    func handleInit() {
        
        viewModel.getFlickrPhotos(keyword: self.searchText)
    }
    
    func handleSearch() {
        
        viewModel.hideKeyboard()
        self.isSearching = true
        
        viewModel.clearPhotos()
        viewModel.getFlickrPhotos(keyword: self.searchText)
    }
    
    func handleCancelSearch() {
        
        viewModel.hideKeyboard()
        self.isSearching = false
        
        self.searchText.removeAll()
        viewModel.clearPhotos()
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MainView()
    }
}
