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
    @IBOutlet weak var saveImageButton: UIButton!
    
    // MARK: - Vars
    var viewModel: MoviewDetailViewModel?
    var subscribers = Set<AnyCancellable>()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = false
        super.viewDidLoad()
        posterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        bindViewModel()
        viewModel?.updateSelectedMovie(completion: { (err) in
            if let error = err{
                let alertController = UIAlertController(title: "Error", message:
                                  error.localizedDescription, preferredStyle: .alert)
                              alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))

                self.present(alertController, animated: true, completion: nil)
            }
        })
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
                self.posterImageView.setImage(from: path) { (image) in
                    DispatchQueue.main.async {
                        self.saveImageButton.isHidden = image == nil
                    }
                }
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
    
    @IBAction func saveImageAction(_ sender: Any) {
        print("Save")
        UIImageWriteToSavedPhotosAlbum(posterImageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Error guardando imagen", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Guardado!", message: "El poster de la pelicula se ha guardado en tu carrete", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    @objc func imageTapped(_ recognizer: UITapGestureRecognizer) {
        guard let imageview = recognizer.view as? UIImageView else {return}
        guard let image = imageview.image else {return}
        
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.backgroundColor = newImageView.backgroundColor?.withAlphaComponent(0.8)
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
          self.view.addSubview(newImageView)
        }, completion: nil)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
          sender.view?.removeFromSuperview()
        }, completion: nil)
    }

}
