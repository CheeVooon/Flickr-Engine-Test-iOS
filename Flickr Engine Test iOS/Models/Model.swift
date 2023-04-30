//
//  Model.swift
//  Flickr Engine Test iOS
//
//  Created by Chee Voon on 30/04/2023.
//

import Foundation

struct DataResponse: Codable {
    
    var status: String?
    var photos: PhotoResponse?
    
    private enum CodingKeys: String, CodingKey {
        
        case status = "stat"
        case photos
    }
}

struct PhotoResponse: Codable {
    
    var photos: [Photo]?
    var page: Int?
    var pages: Int?
    var perPage: Int?
    var total: Int?
    
    private enum CodingKeys: String, CodingKey {
        
        case photos = "photo"
        case page
        case pages
        case perPage = "perpage"
        case total
    }
}

struct Photo: Identifiable, Codable {
    
    var id = UUID()
    
    var photoID: String?
    var secret: String?
    var isFamily: Bool?
    var isPublic: Bool?
    
    var farm: Int?
    var owner: String?
    var server: String?
    var urlMedia: String?
    
    var title: String?
    var isFriend: Bool?
    var height: Int?
    var width: Int?
    
    private enum CodingKeys: String, CodingKey {
        
        case photoID = "id"
        case secret
        case isFamily = "isfamily"
        case isPublic = "ispublic"
        
        case farm
        case owner
        case server
        case urlMedia = "url_m"
        
        case title
        case isFriend = "isfriend"
        case height = "height_m"
        case width = "width_m"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.photoID = try container.decodeIfPresent(String.self, forKey: .photoID)
        self.secret = try container.decodeIfPresent(String.self, forKey: .secret)
        if let isFamilyInt = try container.decodeIfPresent(Int.self, forKey: .isFamily), let isFamily = isFamilyInt.toBool() {
            
            self.isFamily = isFamily
        }
        if let isPublicInt = try container.decodeIfPresent(Int.self, forKey: .isPublic), let isPublic = isPublicInt.toBool() {
            
            self.isPublic = isPublic
        }
        self.farm = try container.decodeIfPresent(Int.self, forKey: .farm)
        self.owner = try container.decodeIfPresent(String.self, forKey: .owner)
        self.server = try container.decodeIfPresent(String.self, forKey: .server)
        self.urlMedia = try container.decodeIfPresent(String.self, forKey: .urlMedia)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        if let isFriendInt = try container.decodeIfPresent(Int.self, forKey: .isFriend), let isFriend = isFriendInt.toBool() {
            
            self.isFriend = isFriend
        }
        self.height = try container.decodeIfPresent(Int.self, forKey: .height)
        self.width = try container.decodeIfPresent(Int.self, forKey: .width)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
