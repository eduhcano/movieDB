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
    
    required init(movie:Movie){
        self.movie = movie
        self.title = movie.title
    }
    
    func updateSelectedMovie(){
        let provider = ServiceProvider<OMDBService>()
        provider.load(service: .getMovie(imdbID: movie.imdbID), decodeType: Movie.self){ result in
            switch result {
            case .success(let updatedMovie):
                self.movie = updatedMovie
            case .failure(let error):
                print(error.localizedDescription)
            case .empty:
                print("No data")
            }
        }
    }
    
    func refreshViewModel(){
        
        self.title = movie.title
        self.posterPath = movie.poster
//        self.year = movie.year
        self.plot = movie.plot
    }
}
