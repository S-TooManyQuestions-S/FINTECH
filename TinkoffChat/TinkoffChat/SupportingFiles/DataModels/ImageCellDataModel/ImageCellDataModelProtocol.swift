//
//  ImageCellDataModelProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 22.04.2021.
//

import UIKit

protocol ImageCellDataModelProtocol {
    var id: Int {get set}
    var imageUrl: URL {get set}
    var image: ImageState {get set}
    
    func loadImagePreview(completion: @escaping () -> Void)
}

enum ImageState {
    
    case placeholder
    case loaded(image: UIImage)
    
    var getImage: UIImage {
        
        switch self {
        case .loaded(let loadedImage):
            return loadedImage
        case .placeholder:
            
            if let defaultPlaceholder = UIImage(named: "defaultPlaceholder") {
                return defaultPlaceholder
            }
            return UIImage()
        }
    }
}
