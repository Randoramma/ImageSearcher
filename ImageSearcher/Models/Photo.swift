//
//  Photo.swift
//  ImageSearcher
//
//  Created by Randy McLain on 10/10/17.
//  Copyright © 2017 Randy McLain. All rights reserved.
//

import Foundation

struct Photo {
    /// the url of the photo.
    let url: String?
    /// the number of likes of the photo.
    let likes: Int?
    /// the number of favorites of the photo.
    let favorites: Int?
    
    init(theUrl: String, theLikes: Int, theFavs: Int ) {
        self.url = theUrl
        self.likes = theLikes
        self.favorites = theFavs
    }
}
