//
//  SearchMovieViewController.swift
//  movieDB
//
//  Created by Eduardo Hernández Cano on 19/12/2019.
//  Copyright © 2019 Eduardo Hernández Cano. All rights reserved.
//

import UIKit

class SearchMovieViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Constants
    
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "MovieCellIdentifier"
    
    // MARK: - Vars
    var viewModel = SearchMovieViewModel()

    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Do any additional setup after loading the view.
    }
    
    private func setupView(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = viewModel.title
    }

}
