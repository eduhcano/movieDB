//
//  SearchMovieViewModel.swift
//  movieDB
//
//  Created by Eduardo Hernández Cano on 19/12/2019.
//  Copyright © 2019 Eduardo Hernández Cano. All rights reserved.
//

import Foundation
import Combine

class SearchMovieViewModel {
    
    // MARK: - Constants
    let title = "MovieDB"
    let minSearchChars = 3
    
    // MARK: - Vars
    var data = PassthroughSubject<[Movie], Never>()
    var foundMovies = [Movie]()
    var cancelables: [AnyCancellable] = []
    var allFound = false
    var currentSearchText:String = ""
    var currentPage:Int = 1
    
    init(){
        bind()
    }
    
    func bind() {
        self.cancelables = [
            data.sink(receiveValue: { updatedMovies in
                self.foundMovies = updatedMovies
            })
        ]
    }
    
    func searchMovies(searchText:String,page:Int=1,completion:@escaping(_  error:Error?)->()){
        currentSearchText = searchText
        currentPage = page
        
        guard searchText.count >= minSearchChars else{
            self.data.send([])
            completion(nil)
            return
        }
        
        let provider = ServiceProvider<OMDBService>()
        provider.load(service: .searchMovies(title: searchText,page:String(page)), decodeType: SearchMovieResponse.self) { result in
            switch result {
            case .success(let resp):
                var newMovies = resp.movies
                if page>1{
                    newMovies = self.foundMovies + newMovies
                }
                self.allFound = newMovies.count < 10
                self.data.send(newMovies)
                completion(nil)
            case .failure(let error):
                switch error {
                case NetworkError.decodingFailed:
                    self.allFound = true
                    completion(nil)
                default:
                    completion(error)
                }
                print(error.localizedDescription)
            case .empty:
                print("No data")
            }
        }
    }
    
    func nextPage(completion:@escaping(_  error:Error?)->()){
        let nextPage = currentPage + 1
        searchMovies(searchText: currentSearchText, page: nextPage) { (error) in
            completion(error)
        }
       
    }


}

