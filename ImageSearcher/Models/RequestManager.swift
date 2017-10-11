//
//  RequestManager.swift
//  ImageSearcher
//
//  Created by Randy McLain on 10/7/17.
//  Copyright © 2017 Randy McLain. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

/*
 API Service class
 1. Create struct containing public members required to use API
 2. Create Singleton - service class should be singleton
 3.
 */
class RequestManager {
    static let sharedInstance = RequestManager()
    private var pageForSearch: Int
    private var pageForEditorsChoice: Int
    
    private struct API {
        
        /// the URL base for the API
        static let baseURL = PrivateConstants.private_store_url
        
        /// The API Key provided to consume the API
        static let apiKey = PrivateConstants.private_pixabay_API_Key
    }
    
    // private initalizer
    private init() {
        self.pageForEditorsChoice = 1;
        self.pageForSearch = 1;
    }
    
    /// Alamofire Service Methods
    /// see https://github.com/Alamofire/Alamofire#parameter-encoding for options on request parameters.
    func getImagesByName(nameToSearch name: String, completionHandler: @escaping (_ photos: [Photo]?, _ error: Error?) -> Void) {
        let queryString = name.URLEncodedValue
        let parameters: [String: Any] = ["key": API.apiKey,
                                         "q": queryString,
                                         "page": pageForSearch,
                                         "per_page": 10]
        // perform request and increment if request succeeds.

        Alamofire.request(API.baseURL, parameters: parameters).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                self.pageForSearch += 1
                let json = JSON(value)
                let photos = self.parseJsonForPhoto(json) // parse for objects
                DispatchQueue.main.async(execute: {
                    completionHandler(photos, nil) // usually return objects on main queue.
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    completionHandler(nil, error)
                    print(error.localizedDescription)
                })
            }
        }
    }
    
    func getImagesByID(imageID id: String) {
        let idQueryString = id.URLEncodedValue
        let parameters: [String: Any] = ["key": API.apiKey, "id": idQueryString]
        
        Alamofire.request(API.baseURL, parameters: parameters).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /*
     Automagically caches each image recieved from network requests to improve responsiveness.  Prior to making network request AlamofireImage checks if the image was requested  previously and if so pulls that image from the cache.  Only works while connecetd to network.
     */
    func getImageByURL(urlOfImage url: String, completionHandler: @escaping (_ image: UIImage?, _ error: Error?) ->Void) {
        Alamofire.request(url).responseImage { (response) in
            switch(response.result) {
            case .success(let value):
                completionHandler(value, nil)
            case .failure(let error):
                print("the error is \(error)")
            }
        }
    }
    
    func getEditorChoiceImages(completionHandler: @escaping (_ photos: [Photo]?, _ error: Error?) -> Void) {
        let parameters: [String: Any] = ["key": API.apiKey,
                                         "editors_choice": true,
                                         "page": pageForEditorsChoice,
                                         "per_page": 10]
        // the fetch request  and increment request variable if request succeeds.
        Alamofire.request(API.baseURL, parameters: parameters).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                self.pageForEditorsChoice += 1
                let json = JSON(value)
                let photos = self.parseJsonForPhoto(json) // parse for objects
                DispatchQueue.main.async(execute: {
                    completionHandler(photos, nil) // usually return objects on main queue.
                })
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    completionHandler(nil, error)
                    print(error.localizedDescription)
                })
            }
        }
    }
    
    fileprivate func parseJsonForPhoto(_ json: JSON)->[Photo] {
        var photoArray = [Photo]()
        guard let hits = json["hits"].array else {
            return photoArray
        }
        for item in hits { // ensure your keys are spelled and typed correctly.  (cmnd+p from results)
            if let url = item["webformatURL"].string,
                let likes = item["likes"].int,
                let favortites = item["favorites"].int {
                let photo = Photo(theUrl: url, theLikes: likes, theFavs: favortites)
                photoArray.append(photo)
            }
        }
        return photoArray
    }
}

public extension String {
    
    /* For performance, I've replaced the char constants with integers, as char constants don't work in Swift.
    https://stackoverflow.com/questions/3423545/objective-c-iphone-percent-encode-a-string/20271177#20271177
 
     */
    var URLEncodedValue: String {
        let output = NSMutableString()
        guard let source = self.cString(using: String.Encoding.utf8) else {
            return self
        }
        let sourceLen = source.count
        
        var i = 0
        while i < sourceLen - 1 {
            let thisChar = source[i]
            if thisChar == 32 {
                output.append("+")
            } else if thisChar == 46 || thisChar == 45 || thisChar == 95 || thisChar == 126 ||
                (thisChar >= 97 && thisChar <= 122) ||
                (thisChar >= 65 && thisChar <= 90) ||
                (thisChar >= 48 && thisChar <= 57) {
                output.appendFormat("%c", thisChar)
            } else {
                output.appendFormat("%%%02X", thisChar)
            }
            
            i += 1
        }
        
        return output as String
    }
}


/*
 hits =     (
 {
 comments = 27;
 downloads = 113;
 favorites = 9;
 id = 2802838;
 imageHeight = 2929;
 imageWidth = 2930;
 likes = 31;
 pageURL = "https://";
 previewHeight = 149;
 previewURL = "https:___.jpg";
 previewWidth = 150;
 tags = "cow, beef, animal";
 type = photo;
 user = Couleur;
 userImageURL = "https://____.jpg";
 "user_id" = 1195798;
 views = 388;
 webformatHeight = 639;
 webformatURL = "https://____.jpg";
 webformatWidth = 640;
 },
 */
