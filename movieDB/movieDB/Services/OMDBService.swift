//
//  OMDBService.swift
//  movieDB
//
//  Created by Eduardo Hernández Cano on 19/12/2019.
//  Copyright © 2019 Eduardo Hernández Cano. All rights reserved.
//

import Foundation


enum OMDBService {
    case searchMovies(title: String,page:String)
    case getMovie(imdbID: String)
}

extension OMDBService: Service {
    var baseURL: String {
        return "https://www.omdbapi.com"
    }

    var path: String {
        switch self {
        case .searchMovies(_):
            return ""
        case .getMovie(_):
            return ""
        }
    }

    var parameters: [String: Any]? {
        // default params
        var params: [String: Any] = ["apikey": "a4d2f2dd"]
        
        switch self {
        case .searchMovies(let title,let page):
            params["t"] = "movie"
            params["s"] = title
            params["page"] = page
            
        case .getMovie(let imdbID):
            params["i"] = imdbID
        }
        return params
    }

    var method: ServiceMethod {
        return .get
    }
}
