//
//  UIImage+Utils.swift
//  movieDB
//
//  Created by Eduardo Hernández Cano on 19/12/2019.
//  Copyright © 2019 Eduardo Hernández Cano. All rights reserved.
//

import UIKit


extension UIImageView {
    func setImage(from url: String,completion:@escaping(_  image:UIImage?)->()) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else {
                completion(nil)
                return
                
            }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.image = image
                completion(image)
            }
        }
    }
}
