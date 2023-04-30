//
//  ViewModel.swift
//  Flickr Engine Test iOS
//
//  Created by Chee Voon on 30/04/2023.
//

import Foundation
import SwiftUI
import Alamofire

class ViewModel: ObservableObject {
    
    @Published var pages: Int = 0
    @Published var page: Int = 1
    
    @Published var photos: [Photo] = []
    
    @Published var isFetching: Bool = false
    
    // Fetch Flickr Photos
    func getFlickrPhotos(keyword: String) {
        
        self.isFetching = true
        
        let requestURL = self.generateURL(keyword: keyword, page: self.page)
        
        AF.request(requestURL, method: .get).response { response in
            
            switch response.result {
                
            case let.success(value):
                
                guard let data = value else { return }
                
                print("Response:")
                print(data.prettyPrintedJSONString ?? "JSON PrettyPrinted Error")
                
                do {
                    
                    let dataModel = try JSONDecoder().decode(DataResponse.self, from: data)
                    
                    self.pages = dataModel.photos?.pages ?? 0
                    
                    self.photos.append(contentsOf: dataModel.photos?.photos ?? [])
                    
                    self.isFetching = false
                }
                
                catch {
                    
                    print("JSON Parsing Error: \(error)")
                    
                    self.isFetching = false
                }
                
            case let.failure(error):
                
                print("Request Error: \(error)")
                
                self.isFetching = false
            }
        }
    }
    
    // Fetch Next Page
    func getMorePhotos(currentPhoto: Photo, keyword: String) {
        
        if self.pages != 0 && self.pages != self.page {
            
            let threshold = self.photos.index(self.photos.endIndex, offsetBy: -4)
            
            if self.photos[threshold].id == currentPhoto.id {
                
                self.page += 1
                self.getFlickrPhotos(keyword: keyword)
            }
        }
    }
    
    // Generate Full URL
    func generateURL(keyword: String, page: Int) -> String {
        
        let apiKey = "89b177ce50bb15ef5991d445988277cc"
        
        let serviceName = "flickr.photos.search"
        
//        let secret = "7a52d018515766c5"
        
        return "https://api.flickr.com/services/rest?api_key=\(apiKey)&method=\(serviceName)&tags=\(keyword)&format=json&nojsoncallback=true&extras=media&extras=url_sq&extras=url_m&per_page=21&page=\(page)"
    }
    
    // Clear Photos
    func clearPhotos() {
        
        self.pages = 0
        self.page = 1
        
        self.photos.removeAll()
    }
    
    // Hide Keyboard
    func hideKeyboard() {
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
