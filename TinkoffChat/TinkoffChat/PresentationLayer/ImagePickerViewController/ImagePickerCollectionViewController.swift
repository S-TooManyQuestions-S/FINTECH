//
//  ImagePickerCollectionViewController.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 21.04.2021.
//

import UIKit

class ImagePickerCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var imagePicker: ImagePickerDelegate?
    
    var imagePickerModel: ImagePickerCollectionModelProtocol = ImagePickerCollectionModel()
    
    private let sectionInsets = UIEdgeInsets(
      top: 20.0,
      left: 20.0,
      bottom: 20.0,
      right: 20.0)
    
    private let numberOfPhotosInRow = CGFloat(3)
    private var photos: [ResponseData] = []
    private var models: [Int: ImageCellDataModelProtocol] = [:]
    
    private let cellIdentifier = String(describing: ImageCollectionViewCell.self)
    var imageList = [ImageCellDataModelProtocol]()
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView?.delegate = self
        imageCollectionView?.dataSource = self
        
        imageCollectionView?.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        imagePickerModel.initialization { [weak self] (result: Response?, errorDescr: String?) in
            if let error = errorDescr {
                Logger.logProcess(fullDescription: error)
                return
            }
            
            guard let response = result else {
                Logger.logProcess(fullDescription: "Response was a nil value!")
                return
            }
            
            self?.photos = response.hits
            
            DispatchQueue.main.sync {
                self?.imageCollectionView.reloadData()
            }
        }
        
        imagePickerModel.setTheme {theme in
            self.imageCollectionView.backgroundColor = theme.getBackGroundColor
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
      ) -> CGSize {

        let paddingSpace = sectionInsets.left * (numberOfPhotosInRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / numberOfPhotosInRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
      }
      
      func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          insetForSectionAt section: Int
      ) -> UIEdgeInsets {
        return sectionInsets
      }
      
      func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
        return sectionInsets.left
      }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
       
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = models[photos[indexPath.row].id] else {
            return
        }
        
        switch model.image {
        case .loaded(let image):
            self.imagePicker?.pickNetImage(image: image)
        case .placeholder:
            self.showPickError()
        }
        backButtonPressed(self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func showPickError() {
        let alert = UIAlertController(title: "Error by choosing a Profile Image",
                                      message: "Picture can't be loaded!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImageCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        if let value = self.models[self.photos[indexPath.row].id] {
            cell.configure(with: value)
        } else {
            if
                let fullImageUrl = URL(string: self.photos[indexPath.row].webformatUrl) {
                let newModel = ImageCellDataModel(id: self.photos[indexPath.row].id,
                                   imageUrl: fullImageUrl)
                cell.configure(with: newModel)
                self.models[newModel.id] = newModel
            }
        }
        return cell
    }
}
