//
//  ImagePickerCollectionModelProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 23.04.2021.
//

import Foundation

protocol ImagePickerCollectionModelProtocol {
    func initialization(completion: @escaping (Response?, String?) -> Void)
    func setTheme(handler: @escaping (Theme) -> Void)
}
