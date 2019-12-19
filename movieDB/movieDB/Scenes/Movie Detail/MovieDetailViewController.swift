//
//  MovieDetailViewController.swift
//  movieDB
//
//  Created by Eduardo Hernández Cano on 19/12/2019.
//  Copyright © 2019 Eduardo Hernández Cano. All rights reserved.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    // MARK: - Vars
    var viewModel: MoviewDetailViewModel?
    var subscribers = Set<AnyCancellable>()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = false
        super.viewDidLoad()
        bindViewModel()
        viewModel?.updateSelectedMovie()
    }
    
    // MARK: - Setup
    func bindViewModel(){
        guard let vm = viewModel else {return}
        
        vm.$title.receive(on: DispatchQueue.main).assign(to:\.text, on: titleLabel).store(in: &subscribers)
        vm.$genre.receive(on: DispatchQueue.main).assign(to:\.text, on: genreLabel).store(in: &subscribers)
        vm.$date.receive(on: DispatchQueue.main).assign(to:\.text, on: dateLabel).store(in: &subscribers)
        vm.$duration.receive(on: DispatchQueue.main).assign(to:\.text, on: durationLabel).store(in: &subscribers)
        vm.$web.receive(on: DispatchQueue.main).assign(to:\.text, on: webLabel).store(in: &subscribers)
        vm.$plot.receive(on: DispatchQueue.main).assign(to:\.text, on: plotTextView).store(in: &subscribers)
        vm.$canOpenWeb.receive(on: DispatchQueue.main).assign(to:\.isEnabled, on: shareButton).store(in: &subscribers)
        subscribers.insert(vm.$posterPath.sink { (posterPath) in
            if let path = posterPath{
                self.posterImageView.setImage(from: path)
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func shareWebAction(_ sender: Any) {
        if let webUrl = viewModel?.web{
            let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [webUrl], applicationActivities: nil)
               self.present(activityViewController, animated: true, completion: nil)
        }

    }
    
    func shareWeb(_ websiteUrl:String){

       
    }

}
