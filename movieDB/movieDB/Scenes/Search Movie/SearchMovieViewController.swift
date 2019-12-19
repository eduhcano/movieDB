//
//  SearchMovieViewController.swift
//  movieDB
//
//  Created by Eduardo Hernández Cano on 19/12/2019.
//  Copyright © 2019 Eduardo Hernández Cano. All rights reserved.
//

import UIKit
import Combine
import CombineDataSources

class SearchMovieViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Constants
    
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "MovieCellIdentifier"
    
    // MARK: - Vars
    var viewModel = SearchMovieViewModel()
    private var pendingRequestWorkItem: DispatchWorkItem? //Cancellable Search workItem
    var subscriptions = [AnyCancellable]()

    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupView()
        setupTable()
        bindViewModel()

        // Do any additional setup after loading the view.
    }
    
    private func setupView(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = viewModel.title
    }
    
    private func setupSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTable(){
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.prefetchDataSource = self
    }
    
    private func bindViewModel(){
        viewModel.data.bind(subscriber: tableView.rowsSubscriber(cellIdentifier: cellIdentifier, cellType: MovieTableViewCell.self, cellConfig: { cell, indexPath, model in
            cell.setMovie(model)
        }))
        .store(in: &subscriptions)
    }

}

extension SearchMovieViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    
    
    // Cancel the currently pending item
    pendingRequestWorkItem?.cancel()

    // Wrap our request in a work item
    let requestWorkItem = DispatchWorkItem { [weak self] in
        if let searchText = self?.searchController.searchBar.text,searchText != self?.viewModel.currentSearchText  {
           
            self?.viewModel.searchMovies(searchText: searchText, completion: { (err) in
                if let error = err{
                    let alertController = UIAlertController(title: "Error", message:
                                      error.localizedDescription, preferredStyle: .alert)
                                  alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))

                    self?.present(alertController, animated: true, completion: nil)
                }
              
            })
        }
    }

    // Save the new work item and execute it after 250 ms
    pendingRequestWorkItem = requestWorkItem
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                  execute: requestWorkItem)
    
  }
}

// MARK: - TableviewDelegate

extension SearchMovieViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedMovie = viewModel.foundMovies[indexPath.row]
//        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
//        let VM = MoviewDetailViewModel(movie: selectedMovie)
//        viewController.viewModel = VM
//        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SearchMovieViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) && !viewModel.allFound {
            viewModel.nextPage(completion: { (err) in
                if let error = err{
                    let alertController = UIAlertController(title: "Error", message:
                                      error.localizedDescription, preferredStyle: .alert)
                                  alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))

                    self.present(alertController, animated: true, completion: nil)
                }
              
            })
        }
    }
}

private extension SearchMovieViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.foundMovies.count - 1
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
