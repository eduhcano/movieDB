//
//  Movie.swift
//  movieDB
//
//  Created by Eduardo Hernández Cano on 19/12/2019.
//  Copyright © 2019 Eduardo Hernández Cano. All rights reserved.
//

import Foundation

struct Movie:Codable,Hashable {
    
    let imdbID:String
    let title:String
    let year:String?
    let poster:String?
    let genre:String?
    let website:String?
    let plot:String?
    
    enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case genre = "Genre"
        case website = "Website"
        case plot = "Plot"
    }

}

struct SearchMovieResponse:Codable{
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}
