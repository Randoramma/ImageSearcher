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
    
    private struct API {
        
        /// the URL base for the API
        static let baseURL = PrivateConstants.private_store_url
        
        /// The API Key provided to consume the API
        static let apiKey = PrivateConstants.private_pixabay_API_Key
    }
    
    // private initalizer
    private init() {
        
    }
    
    /// Alamofire Service Methods
    /// see https://github.com/Alamofire/Alamofire#parameter-encoding for options on request parameters.
    func getImagesByName(nameToSearch name: String, completionHandler: @escaping (_ photos: [Photo]?, _ error: Error?) -> Void) {
        let parameters: [String: Any] = ["key": API.apiKey, "q": name]
        Alamofire.request(API.baseURL, parameters: parameters).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
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
        let parameters: [String: Any] = ["key": API.apiKey, "id": id]
        
        Alamofire.request(API.baseURL, parameters: parameters).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
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
        let parameters: [String: Any] = ["key": API.apiKey, "editors_choice": true]
        // the fetch request
        Alamofire.request(API.baseURL, parameters: parameters).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
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
