//
//  SMRequest.swift
//  TeamSounds
//
//  Created by Said Marouf on 7/28/15.
//  Copyright (c) 2015 Said Marouf. All rights reserved.
//

import Foundation
import Alamofire

enum SCRequest: URLRequestConvertible {
    
    // MARK: Config
    
    private static let baseURLString = "https://api.soundcloud.com"
    
    
    // MARK: APIs
    case Search(q: String, clientID: String, token: String)
    case OAuth
    
    private var method: Alamofire.Method {
        switch self {
        case .Search:
            return .GET
        case .OAuth:
            return .GET
        }
    }
    
    private var path: String {
        switch self {
        case .Search:
            return "/tracks.json"
        case .OAuth:
            return "oauth2/token/"
        }
    }
    
    var URLRequest: NSURLRequest {
        
        let URL = NSURL(string: SCRequest.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
            
        case .Search(let q, let cliendID, let token):
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["q" : q, "client_id": cliendID, "oauth_token": token]).0
            
        case .OAuth:
            return ParameterEncoding.JSON.encode(mutableURLRequest, parameters: [:]).0
            
        default:
            println("path: \(URL.URLByAppendingPathComponent(path))")
            return mutableURLRequest
        }
    }
    
    
    //Move outside to a specific engine class that uses this Enum
    
    
}