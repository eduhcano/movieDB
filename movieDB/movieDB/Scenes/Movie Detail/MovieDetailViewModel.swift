//
//  MovieDetailViewModel.swift
//  movieDB
//
//  Created by Eduardo Hernández Cano on 19/12/2019.
//  Copyright © 2019 Eduardo Hernández Cano. All rights reserved.
//

import Foundation

class MoviewDetailViewModel {
    var movie:Movie {
        didSet{
            refreshViewModel()
        }
    }

    @Published var title: String?
    @Published var genre: String?
    @Published var date: String?
    @Published var duration: String?
    @Published var web: String?
    @Published var posterPath: String?
    @Published var plot: String?
    @Published var canOpenWeb:Bool = false
    
    required init(movie:Movie){
        self.movie = movie
        self.title = movie.title
    }
    
    func updateSelectedMovie(completion:@escaping(_  error:Error?)->()){
        let provider = ServiceProvider<OMDBService>()
        provider.load(service: .getMovie(imdbID: movie.imdbID), decodeType: Movie.self){ result in
            switch result {
            case .success(let updatedMovie):
                self.movie = updatedMovie
                completion(nil)
            case .failure(let error):
                completion(error)
            case .empty:
                completion(nil)
                print("No data")
            }
        }
    }
    
    func refreshViewModel(){
        
        self.title = movie.title
        self.posterPath = movie.poster
        self.date = movie.released
        self.genre = movie.genre
        self.duration = movie.runtime
        self.web = movie.website //test functionality "https://apple.com"
        self.plot = movie.plot
        self.canOpenWeb = self.web?.isValidURL ?? false
    }
}
