//
//  ImageCollectionViewCell.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 21.04.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView?
    
    func configure(with imageCellDataModel: ImageCellDataModelProtocol) {
        imageCellDataModel.loadImagePreview { [weak self] in
            DispatchQueue.main.async {
                self?.image?.image = imageCellDataModel.image.getImage
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image?.image = UIImage(named: "defaultPlaceholder")
    }
    
}
