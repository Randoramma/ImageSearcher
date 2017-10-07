//
//  RequestManager.swift
//  ImageSearcher
//
//  Created by Randy McLain on 10/7/17.
//  Copyright © 2017 Randy McLain. All rights reserved.
//

import Foundation

class RequestManager {
    static let sharedInstance = RequestManager()
    
    private struct API {
        
        /// the URL base for the API
        static let baseURL = "https//pixabay.com/api/"
        
        /// The API Key provided to consume the API
        static let apiKey = PrivateConstants.private_pixabay_API_Key
    }

    private init() {
        
    }
    
    
}
