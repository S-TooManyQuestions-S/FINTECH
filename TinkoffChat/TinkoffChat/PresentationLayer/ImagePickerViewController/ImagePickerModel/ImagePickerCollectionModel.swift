//
//  ImagePickerCollectionModel.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 23.04.2021.
//

import Foundation

class ImagePickerCollectionModel: ImagePickerCollectionModelProtocol {
    func initialization(completion: @escaping (Response?, String?) -> Void) {
        RootAssembly.serviceAssembly.networkHandler.getImagesArray(resultHandler: completion)
    }
    func setTheme(handler: @escaping (Theme) -> Void) {
        handler(RootAssembly.serviceAssembly.themeHandler.getTheme())
    }
}
