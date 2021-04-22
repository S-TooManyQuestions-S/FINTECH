//
//  ImageCellDataModel.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 22.04.2021.
//

import UIKit

class ImageCellDataModel: ImageCellDataModelProtocol {
    
    var id: Int
    var imageUrl: URL
    var image: ImageState
    
    init(id: Int, imageUrl: URL) {
        self.id = id
        self.imageUrl = imageUrl
        self.image = .placeholder
    }
    
    func loadImagePreview(completion: @escaping () -> Void) {
        
        DispatchQueue.global().async { [weak self] in
            if let previewUrl = self?.imageUrl,
               let data = try? Data(contentsOf: previewUrl),
               let image = UIImage(data: data) {
                self?.image = .loaded(image: image)
            } else {
                self?.image = .placeholder
            }
            completion()
        }
    }
}
