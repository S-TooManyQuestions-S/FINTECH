//
//  NetworkHandlerProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Самаренко on 22.04.2021.
//

import Foundation

protocol NetworkHandlerProtocol {
    func getImagesArray(resultHandler: @escaping (Response?, String?) -> Void)
}
